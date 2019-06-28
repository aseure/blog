import datetime
import os
import re
import shutil
import sys


def dir_exists(d):
    return os.path.exists(d) and os.path.isdir(d)

def file_exists(f):
    return os.path.exists(f) and os.path.isfile(f)

def remove_dir(d):
    if dir_exists(d):
        shutil.rmtree(d)

def remove_file(f):
    if file_exists(f):
        os.remove(f)

def check_valid_date(d):
    try:
        datetime.datetime.strptime(d, '%Y-%m-%d')
    except ValueError:
        print(f"Invalid date format '{d}' (was expecting 'YYYY-MM-DD')")
        sys.exit(1)

if len(sys.argv) != 2:
    print('Usage: ./blogit.sh <INPUT_TEXT_BUNDLE>')
    sys.exit(1)

input_textbundle      = os.path.expanduser(sys.argv[1])
output_hugo_posts_dir = os.path.expanduser('content/posts/')

if not dir_exists(input_textbundle):
    print(f'Input TextBundle {input_textbundle} does not exist')
    sys.exit(1)

if not dir_exists(output_hugo_posts_dir):
    print(f'Output posts directory {output_hugo_posts_dir} does not exist')
    sys.exit(1)

if not input_textbundle.endswith('.textbundle'):
    print(f'Input Textbundle {input_textbundle} does not have a .textbundle extension')
    sys.exit(1)

date_article_name     = os.path.basename(input_textbundle[:len(input_textbundle)-len('.textbundle')])
date                  = date_article_name[:10]
article_name          = date_article_name[13:]

check_valid_date(date)

article_filename      = re.sub(r' ', '-', (date + '-' + article_name).lower())
output_post_markdown  = os.path.join(output_hugo_posts_dir, article_filename + '.md')
output_post_dir       = os.path.join(output_hugo_posts_dir, article_filename)

print(f':: {article_name}')

remove_file(output_post_markdown)
remove_dir(output_post_dir)

shutil.copy(
    os.path.join(input_textbundle, 'text.md'),
    output_post_markdown,
)

input_assets_dir = os.path.join(input_textbundle, 'assets')

if dir_exists(input_assets_dir):
    shutil.copytree(
        input_assets_dir,
        os.path.join(output_post_dir, 'assets'),
    )

front_matter = ('---'                    +  '\n' +
               'title: "' + article_name + '"\n' +
               'date:  "' + date         + '"\n' +
               '---\n\n')

with open(output_post_markdown, 'r+') as f:
    next(f) # Skip first line
    content = f.read()

with open(output_post_markdown, 'w+') as f:
    f.write(front_matter)
    f.write(content)
