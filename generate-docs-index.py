
import os

from datetime import datetime
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, select_autoescape
from markupsafe import Markup
from urllib.parse import urlparse

template = env.get_template("ontologies-index.html")

htmlfiles = list(Path(".").glob("./meta/html/*/*.html"))

print(htmlfiles)