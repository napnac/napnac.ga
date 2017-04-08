import glob
import jinja2
import markdown
import os
import sys

from markdown.extensions.toc import TocExtension
# Python-Markdown third party extension
import figureAltCaption


ARTICLE_DIR      = 'content/articles'
PAGE_DIR         = 'content/pages'
TEMPLATE_DIR     = 'content/templates'
WEBSITE_DIR      = 'website'

ARTICLE_TEMPLATE = 'article.html'
PAGE_TEMPLATE    = 'default.html'

jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(TEMPLATE_DIR))
# To get rid of useless empty lines in the html output
jinja_env.trim_blocks   = True
jinja_env.lstrip_blocks = True


def full_render(template, html, metadata, toc):
    output = template.render({
            'html_content': html,
            'metadata': metadata,
            'toc': toc
            })
    path = os.path.join(WEBSITE_DIR, metadata['path'])
    with open(path, 'w+') as f:
        f.write(output)


def read_markdown(path):
    with open(path, 'r') as f:
        content = f.read()

    # Parse the content
    md = markdown.Markdown(extensions={
        'markdown.extensions.extra',
        'markdown.extensions.meta',
        TocExtension(marker='', toc_depth=2),
        'figureAltCaption'
        })
    html = md.convert(content)
    metadata = md.Meta
    toc = md.toc

    # The metadata values are lists but we want strings
    for key, value in metadata.items():
        key = key.lower()
        metadata[key] = ''.join(value)
    # Format the metadata
    metadata['path'] = os.path.join(metadata['path'], os.path.basename(path))
    metadata['path'] = metadata['path'].replace('.md', '.html')

    # Test if the toc is empty
    if 'li' not in toc:
        toc = ''

    return html, metadata, toc


def basic_render(path, template_path):
    template = jinja_env.get_template(template_path)
    html, metadata, toc = read_markdown(path)
    full_render(template, html, metadata, toc)


def get_path_files(directory, extension):
    return glob.iglob(directory + '/**/*.' + extension, recursive=True)


def render_pages():
    for page in get_path_files(PAGE_DIR, 'md'):
        basic_render(page, PAGE_TEMPLATE)


def render_articles():
    for article in get_path_files(ARTICLE_DIR, 'md'):
        basic_render(article, ARTICLE_TEMPLATE)


# We can specify the files we only want to render
if len(sys.argv) > 1:
    for f in sys.argv[1:]:
        print("Rendering: ", os.path.basename(f))
        if PAGE_DIR in f:
            basic_render(f, PAGE_TEMPLATE)
        elif ARTICLE_DIR in f:
            basic_render(f, ARTICLE_TEMPLATE)
# Or, we can render all the files
else:
    print("Rendering pages...")
    render_pages()
    print("Rendering articles...")
    render_articles()
    print("Done!")
