/* Mar 2016 */
var webdriver = require('selenium-webdriver');
var by = webdriver.By;
var Profile = require('./profile');
var logger = require('./logger');
var settings = {
	like: true,
	sleep_delay: 2200,
	account_username: 'username',
	account_password: 'password',
	count_pages: 4	
};

//если вы хотите использовать скрипт только в консоли, нужно заменить firefox на phantomjs
var browser = new webdriver
    .Builder()
    .withCapabilities(webdriver.Capabilities.firefox())
    .build();

browser.manage().window().setSize(1024, 700);
browser.get('https://badoo.com/signin/');
browser.sleep(settings.sleep_delay);
browser.findElement(by.name('email')).sendKeys(settings.account_username);
browser.findElement(by.name('password')).sendKeys(settings.account_password);
browser.findElement(by.xpath('//button')).click();
browser.sleep(settings.sleep_delay);
browser.sleep(settings.sleep_delay).then(function() {
	search_users_on_page(1);
}).then(function() {
	logger.info('Begin view profiles...');
	view_profiles();
});

function search_users_on_page(indexPage) {
    if (indexPage >= settings.count_pages) {
        logger.info('Everything is done. Finishing...');
        return;
    }
	var user = {};
	browser.sleep(settings.sleep_delay);
	browser.get('https://eu1.badoo.com/search?page='+indexPage);
	browser.sleep(settings.sleep_delay*2);
	var promise = new webdriver.promise.Promise(function(resolve, reject){
		browser.findElements(by.css("figure")).then(function (figures) {
	      for (var i = 0; i < figures.length; i++) {
	        figures[i].getAttribute('data-user-id').then(function(value){
	      		user.id = value;
	      	}); 
	        figures[i].findElement(by.css('.user-card__info-name')).getText().then(function(value){
	      		user.age = value.slice(-2);
	        });
	        figures[i].findElement(by.css('.user-card__info-name_')).getText().then(function(value){
	      		user.name = value;
	      		logger.debug(user.id + ' ' + user.name + ' ' + user.age);
	      		save_profile(user);
	      		resolve();
	        });    
	      }
	    });
	});
	promise.then(function() {
        indexPage++;
        search_users_on_page(indexPage);
    });
}

function save_profile(user) {
	Profile.count({id:user.id}, function(err, count){
	  if(err) logger.error(err);
	  else {
	  	if(count <= 0) {
	  		Profile.create({id:user.id, name: user.name, age:user.age, completed: false}, function(err, data){
			    if(err) logger.error(err);
			    else logger.info(user.id + ' saved');
			});
	  	}
	  }
	});
}

function update_profile(userId, note, rewrite) {
	if (rewrite === undefined) {
    	rewrite = false;
  	}
	logger.info('update profile in database: ' + userId);
	Profile.findOneAndUpdate({id:userId, completed: rewrite}, {completed: true, note:note}, {upsert:false}, function (err) {
		if(err) logger.error(err);
	});
}

function click_profile(userId) {
	browser.sleep(settings.sleep_delay*4);
	browser.get('https://eu1.badoo.com/profile/0' + userId);
	browser.sleep(settings.sleep_delay).then(function() {
		logger.debug('--- Click profile: ' + userId + ' ---');
		browser.findElement(by.className("im-open-user")).then(function (value) {
			update_profile(userId, null);
		}, function(err) {
	        logger.error(err);
	        console.log("\007");
		});
		if (settings.like) {
			browser.findElement(by.css(".btn-game")).then(function (game) {
				game.getAttribute('class').then(function(classname) {
	            	logger.debug('CSS Classname: ' + classname);
	            	if (classname.indexOf('js-profile-header-vote-yes') > 0) {
	            		logger.debug('Doing likes for: ' + userId);
	            		game.click();
	            	}
	        	});
			}, function(err) {
		        if (err.state) {
		            logger.error(err);
		        }
			});
		}
		browser.findElement(by.css(".profile-section__txt")).getText().then(function (value) {
			logger.debug('section__txt: ' + value);
			update_profile(userId, value, true);
		}, function(err) {
	        if (err.state) {
	            logger.error(err);
	        }
		});
	});
}

function view_profiles() {
	Profile.find({ completed: false }, function (err, data) {
	  if (err) return logger.error(err);
	  else {
		data.forEach(function(elem, index, array) {
		    click_profile(elem.id);
		});
	  }
	});
}
