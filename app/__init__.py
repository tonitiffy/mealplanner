from flask import Flask
from flask.ext.mysql import MySQL

mysql = MySQL()
app = Flask(__name__)

app.secret_key = 'why would I tell you my secret key?'

app.config['MYSQL_DATABASE_USER'] = 'admin'
app.config['MYSQL_DATABASE_PASSWORD'] = 'password'
app.config['MYSQL_DATABASE_DB'] = 'mealplanner'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

from app import views
