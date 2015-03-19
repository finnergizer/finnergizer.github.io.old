---
layout: post
title:  "Border-box CSS sizing and expanding a div within a div"
date:   2014-12-22
categories: css design
comments: true
---

<style>
    #parent-div {
        width: 300px;
        height: 300px;
        background-color: red;
    }
    #child-div {
        width: 100%;
        padding: 0px 50px;
        height: 150px;
        background-color: blue;
        color: white;
    }

    #child-div-bb {
        width: 100%;
        padding: 0px 50px;
        height: 150px;
        background-color: blue;
        color: white;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        -webkit-box-sizing: border-box;
    }
</style>

##The Problem
When styling an application that I was developing, I came across the problem of trying to expand a child div to fit the
width of its parent while also having a nice padding to ensure that the content in the div was not flush up against the
parent div. Naturally, I tried to set **width:100%** as seen in the following code.


**CSS:**

    #parent-div {
        width: 300px;
        height: 300px;
        background-color: red;
    }
    #child-div {
        width: 100%;
        margin: 50px;
        height: 150px;
        background-color: blue;
        color: white;
    }


**HTML:**

    <div id="parent-div">
        <div id="child-div">
        </div>
    </div>

But this outputs a strange result:

<div id="parent-div">
    This is the parent div.
    <div id="child-div">
        This is the child div.
    </div>
</div>
<br>
When exploring the problem, I noticed that the width was 300 pixels, effectively *filling* it to be the same size as the
parent div that was 300 pixels wide. Initially, I was pleased to see that the width was matching its parent, but still
confused as to why it appeared so much larger than its parent. After a few shakes of my head, I quickly noticed
(after foolishly overlooking, of course) that the element also had 50 pixels of padding on each side, and technically,
the child div was 400 pixels wide, thus explaining its larger appearance in the rendered result.

**So, the problem lies in the fact that the width:100% will set the width property to be exactly the same size as its
parent, but does not account for the padding that is specified**, and as a result, the padding pushes the child div
outside of the parent. The total width of the child div, including the padding, is larger than the width of the parent.

##The solution

When setting width:100%, I had hoped that this would expand the child div's width as large as necessary to fill its parent
while respecting the padding that was set. Afterall, I just wanted the div to expand to fit its parent - not overflow out
of it as seen.

While at first I was confused as to what was causing this weird result, when I identified the problem as the padding, it
became easier to search for a solution. I soon came across a CSS property that would enable width declarations to
*include* the padding and border in the calculated width of the HTML element - **box-sizing**.

The box-sizing property is an indicator for the height and width properties, determining what parts (margin, border,
padding, and content) of the element these properties should include. When this property is not explicitly set in your
CSS styling for an element, it will default to **box-sizing:content-box**. This value indicates that height and width
settings will include only content and not the margin, border, and padding. Since this is the default behaviour, the result
seen above started to make sense - the width setting only included the content and not the padding as we realized.

The only other value for the CSS box-sizing property is *border-box*, and as the name implies, it indicates that the
width and height properties of the element will include everything from the border inwards (i.e. border, padding, content),
and exclude the margin. Already, this description seems to fit the exact result that is wanted from expanding a child
div with padding to fit the entire width of its parent.  Lets give it a shot...


**CSS:**
<pre>
#parent-div {
    width: 300px;
    height: 300px;
    background-color: red;
}
#child-div {
    width: 100%;
    margin: 50px;
    height: 150px;
    background-color: blue;
    color: white;
    <b>

    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    box-sizing: border-box
    </b>
}
</pre>

*Note: You may wonder why there is the box-sizing property followed by two similar properties differing only by their prefixes. This is
because before the box-sizing property became an officially released specification, vendors implemented their own
versions of the property for use in browsers (and they did not want any namespace conflicts when it did become an officially
released specification). Typically adding these prefixed properties allow for older browser versions
to support the property if they do not implement it since the browser versions were released before the official specification.*

**HTML:**

    <div id="parent-div">
        <div id="child-div">
        </div>
    </div>

And this gives:

<div id="parent-div">
    This is the parent div.
    <div id="child-div-bb">
        This is the child div.
    </div>
</div>
<br>

Voila! The original *desired* result is achieved and there is no gross overflow. While this is a simple fix, I feel it is noteworthy
since I thought that this would be the default behaviour of width:100% (but then again, maybe I am a bit different). Either
way, I hope that anyone bumping into this problem will stumble across this post and avoid too lengthy of a troubleshooting venture.
I feel like this is one of those problems that you cannot forget once solved, and I'm sure it will be an issue that
every web developer will come across sometime during their work. Cheers to a first blog post ever!
