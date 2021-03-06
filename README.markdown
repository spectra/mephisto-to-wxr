Mephisto to WordPress eXtended RSS (WXR)
========================================

This rake task helps convert your Mephisto blog to WXR so you can import your articles and comments into WordPress.

Getting Started
===============

Clone this repository from GitHub:

    git clone git://github.com/spectra/mephisto-to-wxr.git

Copy wxr.rake to your Mephisto instance:

    cp mephisto-to-wxr/wxr.rake /path/to/my/app/lib/tasks

Export your articles to WXR:

    rake wxr:export MEPHISTO_SITE="mysite.com" > mysite.wxr

Remember to set your RAILS_ENV. Maybe you should run it like this:

    RAILS_ENV=production rake wxr:export MEPHISTO_SITE="mysite.com" > mysite.wxr

Also, you may not have uuidtools (or you might have an old Ruby/Gems environment). If that's so, you can use any tool that generate a UUIDv4 (or any other unique scheme that you like) instead. For using uuidgen (from e2fsprogs or package uuid-runtime in Debian, for instance), here is an example:

    UUIDGEN=/usr/bin/uuidgen rake wxr:export MEPHISTO_SITE="mysite.com" > mysite.wxr

License
=======

(The MIT License)

Copyright (c) 2009 [Jade Meskill][iamruinous], [integrum][]
Copyright (c) 2011, [Paul Gross][pgr0ss]
Copyright (c) 2012, [Pablo Lorenzzoni][spectra]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[integrum]: http://integrumtech.com
[iamruinous]: http://iamruinous.com
[pgr0ss]: http://www.pgrs.net/
[spectra]: http://www.nardol.org/
