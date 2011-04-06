# HTTP Tracker - A simple and modular rack middleware to track http requests

## Instalation

  gem install http\_tracker

## Description

  HTTPTracker provides a simple interface to add trackers that inspect the requests made to your web application.

## Usage

  Define a tracker using HTTPTracker::Manager and configure the middleware in your framework of choice. 
  (There are some sinatra examples in the examples directory.)

### Dummy Tracker

  HTTPTracker::Manager.add(:my\_tracker) do

    def valid?(env)
      \# This tracker will only execute if the valid method returns true
      \# The implemenation of this method is obligatory.
      true
    end
    
    def before_call(env)
      \# This method can be thinked of as a callback and will run before_call
      \# the rack call to @app.call(env)
      \# You can set instance classes here and use them later in the after_call method.
    end

    def after_call(env, status, headers, body)
      \# This method will run before @app.callback
      \# You can use it to finalize your tracking logic, read variables set in #before_call,
      \# save requests or responses status to a database, etc..
    end
  end

### Using classes as trackers
  class MyTracker
    def initialize
    end

    def valid?(env)
    end

    def before_call(env)
    end

    def after_call(env, status, headers, body)
    end
  end

  HTTPTracker::Manager.add(:my\_tracker, MyTracker)

### Setting multiple trackers

  HTTPTracker::Manager.add(:request\_time) do
    def initialize
      @storage = initialize_my_storage
    end

    def valid?(env)
      true
    end

    def before_call(env)
      @start = Time.now
    end

    def after_call(env, status, headers, body)
      @storage.save({ :request\_time => (Time.now - @start) })
    end
  end

  HTTPTracker::Manager.add(:admin\_tracker) do
    def valid?(env)
      # Only track calls to the admins\_controller
      env["PATH_INFO"] =~ /admins\//
    end

    def before_call(env)
      # Do stuff
    end

    def after_call(env, status, headers, body)
      # Do some other stuff
    end
  end
  

### More examples

  Take a look at the examples directory.

## Credits

  HTTPTracker design is heavly inspired by Warden http://github.com/hassox/warden

# License

(The MIT License)
 
Copyright (c) 2011 Dalto Curvelano Junior
 
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  
