import cgi
from HTMLParser import HTMLParser
import urllib
import re
import hashlib
import hmac
import random
import string
JSON_CONTENT_TYPE =  'application/json; charset=UTF-8'

"""
escapes an HTML string
"""
def escape_html(s):
    return cgi.escape(s, quote = True)

"""
unescapes an HTML string
"""
def unescape_html(s):
    return HTMLParser.unescape.__func__(HTMLParser, s)

"""
decodes a URI
"""
def url_decode(s):
    return urllib.unquote(s.encode('ascii'))

"""
checks valid username
"""
USER_RE = re.compile(r"^[a-zA-Z0-9_-]{3,20}$")
def valid_username(username):
    return username and USER_RE.match(username)

"""
checks valid password
"""
PASS_RE = re.compile(r"^.{3,20}$")
def valid_password(password):
    return password and PASS_RE.match(password)

"""
checks valid email
"""
EMAIL_RE  = re.compile(r'^[\S]+@[\S]+\.[\S]+$')
def valid_email(email):
    return not email or EMAIL_RE.match(email)

###### Security stuff

SECRET = 'stupidhacker'
"""
has a string using a SECRET
"""
def hash_str(s):
    return hmac.new(SECRET, s, hashlib.sha256).hexdigest()
    #return hashlib.md5(s).hexdigest()
"""
adds hash value to the string
"""
def make_secure_val(s):
    return "%s|%s" % (s, hash_str(s))

"""
checks a string hash pairs validity
"""
def check_secure_val(h):
    val = h.split('|')[0]
    if h == make_secure_val(val):
        return val

"""
returns a string of 5 random
letters useing python's random module.
"""
def make_salt():
    return ''.join(random.choice(string.letters) for x in xrange(5))

"""
returns a hashed password 
of the format: 
HASH(name + pw + salt),salt
uses sha256
"""
def make_pw_hash(name, pw, salt=None):
    if not salt:
        salt = make_salt()
    h = hashlib.sha256(name+pw+salt).hexdigest()
    return '%s,%s' % (h, salt)

"""
returns True if a user's password 
matches its hash.
"""
def valid_pw(name, pw, h):
    salt = h.split(',')[1]
    return h == make_pw_hash(name, pw, salt)


def main():
    print url_decode(u'http://dbpedia.org/resource/Moli%C3%A8re_%281978_film%29')

if __name__ == "__main__":
    main()