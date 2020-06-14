from pathlib import Path
import os
from translit import translate
import imghdr
import base64
import pickle
from lxml import html	
import urllib.request


class Note(object):
    categories = {
        'css': '/CSS',
        'cssbattle': '/cssbattle',
        'html': '/HTML',
        'js': '/JS',
        'php': '/PHP',
        'others': '/Others',
        'linux': '/Linux',
        'oracle': '/Oracle',
        'csharp': '/Csharp',
        'python': '/Python',
        'sql': '/SQL'
    }
    articles_dir = '/Pages'
    include_suffix = ('.css', '.html', '.js', '.php', '.txt', '.py', '.cs', '.jpg', '.png', '.sh', '.sql', '.bat')
    cache_dir = os.path.abspath(os.path.dirname(__file__)) + os.sep + 'cache' + os.sep

    def get_cache(self, cachefile):
        try:
            with open(self.cache_dir + cachefile, 'rb') as f:
                cache = pickle.load(f)
        except:
            cache = None
        return cache

    def set_cache(self, cachefile, data):
        with open(self.cache_dir + cachefile, 'wb') as f:
            pickle.dump(data, f)

    def get_menu(self, category=None):
        links = self.get_cache('cache_menu')
        if links is None:
            links = {}
            for cat, val in self.categories.items():
                links[cat] = self.create_links(cat)
            self.set_cache('cache_menu', links)

        if category is not None:
            return links[category]
        else:
            return links

    def get_menu_categories(self):
        data = []
        links = self.get_menu()
        for key, val in links.items():
            if isinstance(val, (dict, list)):
                item = {'href': '/note/' + key, 'title': '{0} ({1})'.format(key, len(val))}
                data.append(item)
        links = self.get_article_list()
        item = {'href': '/articles', 'title': 'articles ({0})'.format(len(links))}
        data.append(item)
        return data

    def create_links(self, category):
        links = {}
        path = self.categories[category]
        web_root_path = os.path.dirname(__file__) + path
        for file in self.get_files(web_root_path):
            file_path = os.path.splitext(file)[0]
            file_name = os.path.basename(file_path)
            file_path = str(file_path)[len(web_root_path) + 1:]
            file_path = file_path.lower()
            file_url = translate(file_path)
            file_url = file_url.replace('/', '-')
            links[file_url] = {
                'href': '<a href="/note/{0}/{1}">{2}</a>'.format(category, file_url, file_name),
                'filePath': file_path
            }
        return links

    def get_files(self, path):
        return [fn for fn in Path(path).glob('**/*.*')
                if Path(fn).suffix.lower() in self.include_suffix]

    def find_files(self, web_root_path, name):
        files = []
        for file in self.get_files(web_root_path):
            file_path = os.path.splitext(file)[0]
            file_path = file_path.lower()
            if file_path == name.lower():
                files.append(file)
        return files

    def get_view_data(self, file, category):
        data = []
        path = self.categories[category]
        web_root_path = os.path.dirname(__file__) + path

        menu = self.get_menu(category)
        file = menu[file]['filePath']
        file = web_root_path + '/' + file
        files = self.find_files(web_root_path, file)

        for f in files:
            content = None
            image_data = None
            file_basename = os.path.basename(f)
            file_name = os.path.splitext(file_basename)[0]
            extension = str(f).split(".")[-1]
            mime = (imghdr.what(f))
            if mime is None:
                content = self.file_get_contents(f)
            else:
                with open(f, "rb") as image_file:
                    encoded_string = base64.b64encode(image_file.read()).decode('ascii')
                image_data = 'data: ' + mime + ';base64,' + encoded_string
                image_data = '<img src="' + image_data + '">'

            data.append({
                'fileName': file_name,
                'code': extension,
                'content': content,
                'image': image_data,
                'category': category
            })
        return data

    def file_get_contents(self, filename):
        encodings = ['utf-8', 'windows-1251']
        for e in encodings:
            try:
                with open(filename, 'r', encoding=e) as f:
                    return f.read()
            except UnicodeDecodeError:
                pass

    def get_article(self, article_id):
        file = os.path.dirname(__file__) + self.articles_dir + os.sep + str(article_id) + '.html'
        content = self.file_get_contents(file)
        root = html.fromstring(content)
        title = root.xpath('//h1/text()')[0]
        return {'content': content, 'title': title}

    def get_article_list(self):
        links = self.get_cache('cache_article_list')
        if links is None:
            links = []
            web_root_path = os.path.dirname(__file__) + self.articles_dir
            for file in self.get_files(web_root_path):
                file_path = os.path.splitext(file)[0]
                file_name = os.path.basename(file_path)
                data = self.get_article(file_name)
                links.append('<a class="list-group-item" href="/?p={0}">{1}</a>'.format(file_name, data['title']))
            self.set_cache('cache_article_list', links)
        return links
