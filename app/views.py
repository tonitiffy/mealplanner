"""
Flask Documentation:     http://flask.pocoo.org/docs/
Jinja2 Documentation:    http://jinja.pocoo.org/2/documentation/
Werkzeug Documentation:  http://werkzeug.pocoo.org/documentation/

This file creates your application.
"""

from app import app, mysql
from flask import render_template, request, redirect, url_for, jsonify, json, session
from werkzeug import generate_password_hash, check_password_hash

###
# Routing for your application.
###

@app.route('/')
def home():
    """Render website's home page."""
    if session.get('user'):
        return render_template('userHome.html')
    return render_template('home.html')
    
@app.route('/signup/', methods=['POST', 'GET'])
def signup():
    if request.method == 'POST':
        try:
            email       = request.form['email'].strip()
            password    = request.form['password'].strip()
            
            if email and password:
                db      = mysql.connect()
                cursor  = db.cursor()
                hashed_password = generate_password_hash(password)
                
                cursor.callproc('sp_createUser',(email,hashed_password))
                data = cursor.fetchall()
    
                if len(data) is 0:
                    db.commit()
                    return json.dumps({'message':'User created successfully !'})
                else:
                    return json.dumps({'error':str(data[0])})
            else:
                return json.dumps({'html':'<span>Enter the required fields</span>'})
                
        except Exception as e:
            return json.dumps({'error':str(e)})
        finally:
            cursor.close() 
            db.close()     
            
    return render_template('signup.html')
    
@app.route('/login/', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        try:
            username = request.form['inputEmail']
            password = request.form['inputPassword']
            
            db      = mysql.connect()
            cursor  = db.cursor()
            cursor.callproc('sp_validateLogin',(_username,))
            data    = cursor.fetchall()
            
            if len(data) > 0:
                if check_password_hash(str(data[0][3]),password):
                    session['user'] = data[0][0]
                    return redirect('/')
                else:
                    return render_template('error.html',error = 'Wrong Email address or Password.')
            else:
                return render_template('error.html',error = 'Wrong Email address or Password.')
                
    
        except Exception as e:
            return render_template('error.html',error = str(e))
        finally:
            cursor.close()
            db.close()
    
    if session.get('user'):
        return render_template('userHome.html')
    else:
        return render_template('signin.html')
    
@app.route('/logout')
def logout():
    session.pop('user',None)
    return redirect('/')


###
# The functions below should be applicable to all Flask apps.
###

@app.route('/<file_name>.txt')
def send_text_file(file_name):
    """Send your static text file."""
    file_dot_text = file_name + '.txt'
    return app.send_static_file(file_dot_text)


@app.after_request
def add_header(response):
    """
    Add headers to both force latest IE rendering engine or Chrome Frame,
    and also to cache the rendered page for 10 minutes.
    """
    response.headers['X-UA-Compatible'] = 'IE=Edge,chrome=1'
    response.headers['Cache-Control'] = 'public, max-age=600'
    return response


@app.errorhandler(404)
def page_not_found(error):
    """Custom 404 page."""
    return render_template('404.html'), 404


if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0",port="8888")
