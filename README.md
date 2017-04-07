# napnac.fr

This is my personal website (in French) where I post articles about algorithms, and my projects. All the articles are written in [Markdown](https://en.wikipedia.org/wiki/Markdown), and then converted with a home made script into HTML pages.

## Conversion script

The script `build.py` uses different Python librairies:

- [Markdown](https://pypi.python.org/pypi/Markdown): to convert Markdown content into HTML pages, with the following extensions:
   - [Extra](https://pythonhosted.org/Markdown/extensions/extra.html): compilation of useful various extensions
   - [Meta-Data](https://pythonhosted.org/Markdown/extensions/meta_data.html): defines meta-data about an article
   - [Table of Contents](https://pythonhosted.org/Markdown/extensions/toc.html): generates a table of contents
   - (Third Party Extension) [figureAltCaption](https://github.com/jdittrich/figureAltCaption): adds captions to images
- [Jinja](http://jinja.pocoo.org/): to create templates for the future HTML pages

## Server

The website is hosted on my [Raspberry Pi](https://www.raspberrypi.org/), which is running an [nginx](http://nginx.org/) server. As for the SSL/TLS certificate, I use [Let's Encrypt](https://letsencrypt.org/).

## License

The content of this website is licensed under the [Creative Commons license](http://creativecommons.org/licenses/by-nc-sa/4.0/), and the source code in this project is licensed under the [MIT license](http://opensource.org/licenses/mit-license.php).
