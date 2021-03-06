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
            username    = request.form['username'].strip()
            password    = request.form['password'].strip()
            firstname   = request.form['firstname'].strip()
            lastname    = request.form['lastname'].strip()
            gender      = request.form['gender'].strip()
            birthday    = request.form['birthday'].strip()
            
            if email and username and password and firstname and lastname and birthday and gender:
                db      = mysql.connect()
                cursor  = db.cursor()
                password_hash = generate_password_hash(password)
                
                cursor.callproc('createUser',(email, username, password_hash, firstname, lastname, gender, birthday))
                data = cursor.fetchall()
    
                if len(data) is 0:
                    db.commit()
                    return json.dumps({'message':'Account successfully created!'})
                else:
                    return json.dumps({'error':str(data[0])})
            else:
                return json.dumps({'html':'<span>All fields are required</span>'})
                
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
            username = request.form['username']
            password = request.form['password']
            
            db      = mysql.connect()
            cursor  = db.cursor()
            cursor.callproc('validateLogin',(username))
            data    = cursor.fetchall()
            
            if len(data) > 0:
                if check_password_hash(str(data[0][3]),password):
                    session['user'] = data[0][0]
                    return redirect('/')
                else:
                    return render_template('error.html',error = 'Wrong username or Password.')
            else:
                return render_template('error.html',error = 'Wrong username or Password.')
                
        except Exception as e:
            return render_template('error.html',error = str(e))
        finally:
            cursor.close()
            db.close()
    
    if session.get('user'):
        return render_template('userHome.html')
    else:
        return render_template('signin.html')
    
@app.route('/logout/')
def logout():
    session.pop('user',None)
    return redirect('/')

@app.route('/addrecipe/', methods=['POST','GET'])
def addrecipe():
    if request.method == 'POST':
        try:
            if session.get('user'):
                title       = request.form['title']
                description = request.form['description']
                
                user        = session.get('user')
    
                db = mysql.connect()
                cursor = db.cursor()
                cursor.callproc('addRecipe',(title,description,user))
                data = cursor.fetchall()
    
                if len(data) is 0:
                    db.commit()
                    return redirect('/userHome')
                else:
                    return render_template('error.html',error = 'An error occurred!')
    
            else:
                return render_template('error.html',error = 'Unauthorized Access')
        except Exception as e:
            return render_template('error.html',error = str(e))
        finally:
            cursor.close()
            db.close()    
    return render_template('addRecipe.html')
    
    
@app.route('/recipes/')
def getRecipes():
    try:
        if session.get('user'):
            _user = session.get('user')

            con = mysql.connect()
            cursor = con.cursor()
            cursor.callproc('sp_GetWishByUser',(_user,))
            recipes = cursor.fetchall()

            recipes_dict = []
            for recipe in recipes:
                recip_dict = {
                        'Id': recipe[0],
                        'Title': recipe[1],
                        'Description': recipe[2],
                        'Date': recipe[4]}
                recipes_dict.append(recip_dict)

            return json.dumps(recipes_dict)
        else:
            return render_template('error.html', error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error = str(e))
        
@app.route('/recipe/<int:recipeid>')
def getRecipe():
    return

@app.route('/mealplan', methods=['POST'])
def generate_mealplan():
    return

@app.route('/mealplans/')
def getMealPlans():
    return
    
@app.route('/mealplan/<int:mealplanid>')
def getMealPlan():
    return
    
@app.route('/mealplan/<int:mealplanid>/shoppinglist', methods=['GET'])
def getShoppingList():
    return

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
