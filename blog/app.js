class App {

  categories = [];
  categoryLinks = {};
  links = [];
  pre = document.createElement('pre');
  code = document.createElement('code');
  content = document.querySelector('#content');
  sideNav = document.querySelector('#side-nav');
  title = document.createElement('h1');

  constructor() {
    this.pre.append(this.code);
    window.addEventListener('hashchange', () => {
      this.router();
    });
  }

  router() {
    const url = window.location.hash.slice(2) || '/';

    if (url === '/') {
      this.renderCategoryLinks(this.categoryLinks);
    } else if (url === 'notes') {
      this.renderCategoryLinks(this.categoryLinks);
    } else {
      const link = this.links.find(x => x.children[0].dataset.id === decodeURI(url));
      const element = (link && link.children) ? link.children[0] : null;

      if (element && element.dataset.id) {
        this.content.innerHTML = '';
        this.title.textContent = element.textContent;
        this.content.append(this.title);
        this.loadContent(element.dataset.id);
        if (element.dataset.img) {
          this.loadImage(element.dataset.img);
        }
      } else {
        const element = this.categories.find(x => x.hash === '#/' + url);

        if (element) {
          const categoryName = element.dataset.category;
          const categoryLinks = {};
          categoryLinks[categoryName] = this.categoryLinks[categoryName];
          this.renderCategoryLinks(categoryLinks);
        } else {
          this.content.innerHTML = '<h3>Not found</h3>';
        }
      }
    }
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
        categoryLinks[item.name] = this.createLinks(item.children || []);
        this.links = this.links.concat(categoryLinks[item.name]);
        category.textContent += ` (${categoryLinks[item.name].length})`;
        categories.push(category);
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
    this.router();
  }

  createCategory(item) {
    const element = document.createElement('a');
    element.classList.add('list-group-item');
    element.href = '#/' + encodeURI(item.path);
    element.textContent = item.name;
    element.dataset.category = item.name;
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
          link.href = '#/' + encodeURI(item.path);
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

}

const app = new App();
app.load();
