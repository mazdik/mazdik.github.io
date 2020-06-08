class App {

  categories = [];
  categoryLinks = {}
  pre = document.createElement('pre');
  code = document.createElement('code');
  content = document.querySelector('#content');
  sideNav = document.querySelector('#side-nav');
  headerNav = document.querySelector('#header-nav');
  title = document.createElement('h1');

  constructor() {
    this.pre.append(this.code);
    this.headerNav.addEventListener('click', (event) => {
      this.onClickHeaderNav(event);
    });
    this.sideNav.addEventListener('click', (event) => {
      this.onClickSideNav(event);
    });
    this.content.addEventListener('click', (event) => {
      this.onClickContent(event);
    });
  }

  async getText(path) {
    let response = await fetch(path);
    let data = await response.text();
    return (response.ok) ? data : null;
  }

  async getJson(path) {
    let response = await fetch(path);
    let data = await response.json();
    return (response.ok) ? data : null;
  }

  async getBlob(path) {
    let response = await fetch(path);
    let data = await response.blob();
    return (response.ok) ? data : null;
  }

  async loadContent(path) {
    let text = await this.getText(path);
    if (text) {
      const extension = path.split('.').pop();
      this.code.textContent = text;
      this.code.className = 'language-' + extension;
      Prism.highlightElement(this.code);
    } else {
      this.code.textContent = 'not found';
    }
    this.content.append(this.pre);
  }

  async loadMenu() {
    const data = await this.getJson('data.json');
    const categories = [];
    const categoryLinks = {}

    if (data && data.children) {
      data.children.forEach(item => {
        const category = this.createCategory(item);
        categories.push(category);
        categoryLinks[item.name] = this.createLinks(item.children || []);
      });
    }
    this.categories = categories;
    this.categoryLinks = categoryLinks;
  }

  async loadImage(path) {
    const blob = await this.getBlob(path);
    if (blob) {
      const img = document.createElement('img');
      this.content.append(img);
      img.src = URL.createObjectURL(blob);
    }
  }

  async load() {
    await this.loadMenu();
    this.renderCategories(this.categories);
    this.renderCategoryLinks(this.categoryLinks);
  }

  createCategory(item) {
    const element = document.createElement('a');
    element.classList.add('list-group-item');
    element.href = item.path;
    element.textContent = item.name;
    return element;
  }

  createLinks(data, elements = []) {
    const imgExtension = ['.jpg', '.png'];
    data.forEach(item => {
      if (!item.children) {
        if (!imgExtension.includes(item.extension)) {
          const element = document.createElement('li');
          const link = document.createElement('a');
          element.append(link);
          link.textContent = item.name;
          link.dataset.id = item.path;
          const img = data.find(x => x.name === item.name && imgExtension.includes(x.extension));
          if (img && img.path) {
            link.dataset.img = img.path;
          }
          elements.push(element);
        }
      } else {
        return this.createLinks(item.children, elements);
      }
    });
    return elements;
  }

  renderCategories(categories) {
    const listGroup = document.createElement('div');
    listGroup.classList.add('list-group');
    listGroup.append(...categories);
    this.sideNav.append(listGroup);
  }

  renderCategoryLinks(categoryLinks) {
    const elements = [];
    for (const key in categoryLinks) {
      const header = document.createElement('h3');
      header.textContent = key;
      elements.push(header);

      const ul = document.createElement('ul');
      ul.classList.add('flex-container');
      ul.append(...categoryLinks[key]);
      elements.push(ul)
    }
    this.content.innerHTML = '';
    this.content.append(...elements);
  }

  onClickContent(event) {
    const target = event.target;
    const element = target.tagName === 'A' ? target : target.closest('a');
    if (!element) {
      return;
    }
    if (element.dataset.id) {
      event.stopPropagation();
      event.preventDefault();
      this.content.innerHTML = '';
      this.title.textContent = element.textContent;
      this.content.append(this.title);
      this.loadContent(element.dataset.id);
      if (element.dataset.img) {
        this.loadImage(element.dataset.img);
      }
    } else if (element.dataset.page) {
      event.stopPropagation();
      event.preventDefault();
      this.content.innerHTML = '';
      this.loadPage(element.dataset.page);
    }
  }

  onClickSideNav(event) {
    const target = event.target;
    const element = target.tagName === 'A' ? target : target.closest('a');
    if (element) {
      event.stopPropagation();
      event.preventDefault();
      const categoryName = element.textContent;
      const categoryLinks = {};
      categoryLinks[categoryName] = this.categoryLinks[categoryName];
      this.renderCategoryLinks(categoryLinks);
    }
  }

  onClickHeaderNav(event) {
    const target = event.target;
    const element = target.tagName === 'A' ? target : target.closest('a');
    if (element && element.dataset.id) {
      event.stopPropagation();
      event.preventDefault();
      if (element.dataset.id === 'note') {
        this.renderCategoryLinks(this.categoryLinks);
      } else if (element.dataset.id === 'articles') {
        this.loadPage('list');
      } else if (element.dataset.id === 'portfolio') {
        this.loadPortfolio();
      }
    }
  }

  async loadPortfolio() {
    let text = await this.getText('portfolio/portfolio.html');
    if (text) {
      this.content.innerHTML = text;
    }
  }

  async loadPage(page) {
    let text = await this.getText(`pages/${page}.html`);
    if (text) {
      this.content.innerHTML = text;
    }
  }

}

const app = new App();
app.load();
