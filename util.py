import cgi
from HTMLParser import HTMLParser
import urllib
import re
import hashlib
import hmac
import random
import string
JSON_CONTENT_TYPE =  'application/json; charset=UTF-8'


def escape_html(s):
    """
    escapes an HTML string
    """
    return cgi.escape(s, quote = True)

def unescape_html(s):
    """
    unescapes an HTML string
    """
    return HTMLParser.unescape.__func__(HTMLParser, s)

def url_decode(s):
    """
    decodes a URI
    """
    return urllib.unquote(s.encode('ascii'))

USER_RE = re.compile(r"^[a-zA-Z0-9_-]{3,20}$")
def valid_username(username):
    """
    checks valid username
    """
    return username and USER_RE.match(username)

PASS_RE = re.compile(r"^.{3,20}$")
def valid_password(password):
    """
    checks valid password
    """
    return password and PASS_RE.match(password)

EMAIL_RE  = re.compile(r'^[\S]+@[\S]+\.[\S]+$')
def valid_email(email):
    """
    checks valid email
    """
    return not email or EMAIL_RE.match(email)

###### Security stuff

SECRET = 'stupidhacker'
def hash_str(s):
    """
    has a string using a SECRET
    """
    return hmac.new(SECRET, s, hashlib.sha256).hexdigest()
    #return hashlib.md5(s).hexdigest()
def make_secure_val(s):
    """
    adds hash value to the string
    """
    return "%s|%s" % (s, hash_str(s))

def check_secure_val(h):
    """
    checks a string hash pairs validity
    """
    val = h.split('|')[0]
    if h == make_secure_val(val):
        return val

def make_salt():
    """
    returns a string of 5 random
    letters useing python's random module.
    """
    return ''.join(random.choice(string.letters) for x in xrange(5))

def make_pw_hash(name, pw, salt=None):
    """
    returns a hashed password 
    of the format: 
    HASH(name + pw + salt),salt
    uses sha256
    """
    if not salt:
        salt = make_salt()
    h = hashlib.sha256(name+pw+salt).hexdigest()
    return '%s,%s' % (h, salt)

def valid_pw(name, pw, h):
    """
    returns True if a user's password 
    matches its hash.
    """
    salt = h.split(',')[1]
    return h == make_pw_hash(name, pw, salt)


def main():
    print url_decode(u'http://dbpedia.org/resource/Moli%C3%A8re_%281978_film%29')

if __name__ == "__main__":
    main()
