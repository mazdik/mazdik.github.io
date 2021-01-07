var comment, view, stat, p404, commentForm, inputsArr, message, regionId, cityId, commentButton, menuElements;

function init() {
    comment = comment || document.getElementById('comment');
    view = view || document.getElementById('view');
    stat = stat || document.getElementById('stat');
    p404 = p404 || document.getElementById('p404');
    menuElements = document.querySelector("ul.menu").children;

    commentForm = document.getElementById("comment-form");
    inputsArr = commentForm.querySelectorAll('input');
    message = document.getElementById("message");

    regionId = document.getElementById("region_id");
    cityId = document.getElementById("city_id");
    commentButton = document.getElementById("comment-button");

    window.addEventListener('hashchange', router);

    regionId.addEventListener('change', onRegionChange);
    commentForm.addEventListener('submit', onCommentSubmit, false);
    view.addEventListener('click', onViewClick);
    stat.addEventListener('click', onStatClick);
}

window.onload = function() {    
    init();
    router();
}


function router() {
    const url = location.hash.slice(1) || '/';

    comment.style.display = 'none';
    view.style.display = 'none';
    stat.style.display = 'none';
    p404.style.display = 'none';

    activeMenu(url);
    if (url === '/') {
    } else if (url === '/comment') {
        loadRegions();
        clearMessages()
        comment.style.display = 'block';
    } else if (url === '/view') {;
        loadComments();
        clearMessages()
        view.style.display = 'block';
    } else if (url === '/stat') {
        loadStat();
        clearMessages()
        stat.style.display = 'block';
    } else {
        clearMessages()
        p404.style.display = 'block';
    }
}

var validations = {
    required: function(value) {
        return value !== '';
    },
    phone: function(value) {
        if (value !== '') {
            return value.match(/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im);
        }
        return true;
    },
    email: function(value) {
        if (value !== '') {
            return value.match(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
        }
        return true;
    }
}

function validate(inputsArr) {
    let isValid = true;
    for (let i = 0; i < inputsArr.length; i++) {
        const attr = inputsArr[i].getAttribute('data-validation');
        const rules = attr ? attr.split(' ') : '';
        const parent = inputsArr[i].closest(".df-group");
        for (let j = 0; j < rules.length; j++) {
            parent.className = "df-group";
            if (!validations[rules[j]](inputsArr[i].value)) {
                parent.className = "df-group df-has-error";
                isValid = false;
            }
        }
    }
    return isValid;
}

function onCommentSubmit(e) {
    e.preventDefault();
    clearMessages();
    if (validate(inputsArr)) {
        commentButton.disabled = true;
        const data = new FormData(commentForm);
        const httpRequest = new XMLHttpRequest();
        httpRequest.onreadystatechange = function() {
            if (this.readyState != 4) {
                return;
            };
            result = JSON.parse(this.responseText);
            message.innerHTML = result['status'];
            window.location.href = '#/view';
            commentForm.reset();
            cityId.innerHTML = '';
            commentButton.disabled = false;
        }
        httpRequest.open('POST', '/insertComment')
        httpRequest.send(JSON.stringify(Object.fromEntries(data)));
    }
}

function fetch(url, cb) {
    const req = new XMLHttpRequest();
    req.open('GET', url);
    req.onload = () => {
        cb(JSON.parse(req.response));
    };
    req.send();
}

function loadRegions() {
    fetch('/getRegions', (data) => {
        regionId.selectedIndex = -1
        regionId.innerHTML = '<option value="0"></option>';
        for (const item of data) {
            regionId.options.add(new Option(item['region_name'], item['id']))
        }
    });
}

function loadCities(regionValue) {
    fetch('/getCities?regionId=' + regionValue, (data) => {
        cityId.selectedIndex = -1
        cityId.innerHTML = '';
        for (const item of data) {
            cityId.options.add(new Option(item['city_name'], item['id']))
        }
    });
}

function loadComments() {
    fetch('/getComments', (data) => {
        view.innerHTML = '';
        const section = document.createElement('section');
        for (const item of data) {
            const newEl = document.createElement('div');
            newEl.className = 'comment';
            city_name = item['city_name'] || '';
            newEl.innerHTML = '<h3>' + item['surname'] + ' ' + item['name'] + '</h3><span>' + city_name +
                '</span><p>' + item['comment'] + '</p><button class="button button-sm" data-comment-id="' +
                item['id'] + '">Delete</button>';
            section.appendChild(newEl);
        }
        view.appendChild(section);
    });
}

function loadStat() {
    fetch('/getStat', (data) => {
        stat.innerHTML = '';
        const section = document.createElement('section');
        for (const item of data) {
            const newEl = document.createElement('div');
            newEl.className = 'comment';
            newEl.innerHTML = '<h3 class="stat-title" data-region-id="' + item['id'] + '">' + item['region_name'] + ' (' + item['cnt'] + ')</h3>';
            section.appendChild(newEl);
        }
        stat.appendChild(section);
    });
}

function clearMessages() {
    message.innerHTML = "";
}

function onRegionChange(e) {
    loadCities(e.target.value)
}

function onViewClick(e) {
    const target = event.target;

    const button = target.closest('.button');
    if (!button) return;
    const commentId = target.getAttribute('data-comment-id');

    if (!confirm('Are you sure?')) {
        return;
    }

    const req = new XMLHttpRequest();
    req.open('DELETE', '/deleteComment?commentId=' + commentId);
    req.onload = () => {
        loadComments();
    };
    req.send();
}

function onStatClick(e) {
    const target = event.target;

    const el = target.closest('.stat-title');
    if (!el) return;
    const id = target.getAttribute('data-region-id');
    parent = target.parentElement;

    fetch('/getStatCity?regionId=' + id, (data) => {
        if (el.nextElementSibling) {
            el.nextElementSibling.remove();
        }
        const section = document.createElement('section');
        section.className = "city-section";
        for (const item of data) {
            const newEl = document.createElement('h3');
            newEl.innerHTML = '&nbsp;' + item['city_name'] + ' (' + item['cnt'] + ')';
            section.appendChild(newEl);
        }
        parent.appendChild(section);
    });

}

function activeMenu(url) {
    for (let i = 0, child; child = menuElements[i]; i++) {
        const el = child.children[0];
        el.classList.remove("active");
        if (el.getAttribute("href").replace('#', '') === url) {
            el.classList.add("active");
        }
    }
}