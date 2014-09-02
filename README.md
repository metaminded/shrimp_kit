[![Code Climate](https://codeclimate.com/github/metaminded/shrimp_kit/badges/gpa.svg)](https://codeclimate.com/github/metaminded/shrimp_kit)

ShrimpKit
---------

ShrimpKit is a basic html renderer for Prawn.

It's *very* work-in-progress, so use at your own risk.

And... How to use?
------------------

either "directly":

<pre>
  ShrimpKit.to_pdf_file('/Users/hornp/Desktop/foo.pdf', "&lt;i&gt;some html&lt;/i&gt;")
</pre>

or within a prawn document:

<pre>
  pdf.html_formatted_text("&lt;i&gt;some html&lt;/i&gt;")
</pre>

Tag Support?
------------

These should kinda work:

* h1
* h2
* h3
* p
* div
* br
* i
* b
* a (wip)
* ul/li
* and some table features

I'm working on it, stay tuned.

Dependencies
------------

* Prawn >= 1.2
* active_support

Licence
-------

MIT. Go for it.
