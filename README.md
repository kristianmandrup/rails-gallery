# Photo Gallery components for Rails

Popular Javascript Photo galleries/carousels ready to use with Rails 3+.

## Usage

`gem 'rails-gallery'

## Galleries included

* slideshow
* responsive
* galleria

Please add more ;)

## Configuration

In `application.css` manifest file:

```css
/*
 * require responsive-gallery
 * require gallery/responsive/elastislide
 * require gallery/responsive/style
 * require gallery/slideshow
 * require gallery/galleria
*/
```

Using Compass, f.ex in `application.css.scss.erb`

```
@import 'gallery/responsive/elastislide';
@import 'gallery/responsive/style';
@import 'gallery/slideshow';
@import 'gallery/galleria';
```

In `application.js` manifest file:

```javascript
//= require gallery/responsive
//= require gallery/slideshow
//= require gallery/galleria

//= require jquery.easing-1.3
//= require jquery.elastislide
//= require jquery.tmpl.min
```

## Minimalistic Slideshow gallery

See [minimalistic-slideshow-gallery](http://tympanus.net/codrops/2010/07/05/minimalistic-slideshow-gallery/) for more info.


### Customization

Pls Fill in here ;)

## Responsive gallery

See [responsive-image-gallery](http://tympanus.net/codrops/2011/09/20/responsive-image-gallery/) for more info.

### Customization

*Remove thumbnails*

Change `mode = 'carousel'` to `'fullview'`

*Remove 'mode' bar*

```css
.rg-view{
  display: none;
}

.rg-thumbs {
  padding-top: 10px;
}
```

*placement of thumbnails*

To adjust placement of thumbnails, use: `prependTo` or `appendTo` in `gallery/responsive.js`:

``javascript
  _addImageWrapper= function() {
    
    // adds the structure for the large image and the navigation buttons (if total items > 1)
    // also initializes the navigation events
    $('#img-wrapper-tmpl').tmpl( {itemsCount : itemsCount} ).prependTo( $rgGallery )
```

*Automatic slideshow*

I wanted the same thing and I find a way to do it.
In the file gallery.js, in the function _initCarousel add these lines after `$esCarousel.elastislide( ‘setCurrent’, current );` (~ line 103):

```javascript
window.setInterval(function(){
_navigate( ‘right’ );
}, 5000);
```

You just have to change 5000 to the value you want (milliseconds).

## Galleria

See [galleria.io](http://galleria.io) for more info.

## Contributing to rails-gallery
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

