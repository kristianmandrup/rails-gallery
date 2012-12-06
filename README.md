# Photo Gallery components for Rails

Popular Javascript Photo galleries/carousels ready to use with Rails 3+.

## Usage

`gem 'rails-gallery'`

## Galleries included

* slideshow
* responsive
* galleria
* touch_touch

Please add more using a similar convention as is used for these galleries ;)

## Configuration

In `application.css` manifest file:

```css
/*
 *= require gallery/responsive/elastislide
 *= require gallery/responsive
 *= require gallery/slideshow
 *= require gallery/galleria/classic
 *= require gallery/touch_touch
*/
```

Using Compass, f.ex in `application.css.scss`

```
@import 'gallery/responsive/elastislide';
@import 'gallery/responsive';
@import 'gallery/slideshow';
@import 'gallery/galleria/classic';
@import 'gallery/touch_touch';
```

In `application.js` manifest file:

```javascript
//= require gallery/responsive
//= require gallery/slideshow
//= require gallery/galleria
//= require gallery/galleria/classic
//= require gallery/touch_touch

//= require jquery/jquery.easing-1.3
//= require jquery/jquery.elastislide
//= require jquery/jquery.tmpl.min
```

## Touch-Touch

```javascript
$(function(){

    // Initialize the gallery
    $('#thumbs a').touchTouch();

});
```

See [TouchTouch](http://tutorialzine.com/2012/04/mobile-touch-gallery/) and [github repo](https://github.com/martinaglv/touchTouch)

```haml
= touchgal_image photo
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

```javascript
  _addImageWrapper= function() {
    
    // adds the structure for the large image and the navigation buttons (if total items > 1)
    // also initializes the navigation events
    $('#img-wrapper-tmpl').tmpl( {itemsCount : itemsCount} ).prependTo( $rgGallery )
```

*Automatic slideshow*

I wanted the same thing and I find a way to do it.
In the file gallery.js, in the function `_initCarousel` add these lines after: 

`$esCarousel.elastislide( 'setCurrent', current );`

```javascript
window.setInterval(function(){
  _navigate( 'right' );
}, 5000);
```

You just have to change `5000` to the value you want (milliseconds).

* Fancybox integration*

First you have to include the js and the css file of fancybox in the file where you have the carousel.

In the file `responsive.js`, replace this line: 

`$rgGallery.find('div.rg-image').empty().append('img src="' + largesrc + '"');` 

With this (which adds 'fancybox' class to all images):

`$rgGallery.find('div.rg-image').empty().append('a class="fancybox"
href="'+largesrc+ '" img src="' + largesrc + '" a');`

In this line, don’t forget to add the `"` for the img and link tags.

Then do the fancybox magic on any class with the `fancybox` class 

```javascript
$(document).ready(function() {
  $(“.fancybox”).fancybox();
});
```

## Galleria

See [galleria.io](http://galleria.io) for more info.

## Rails engine usage

This gem is a Rails 3+ engine :)

Some *HAML* views (partials) are included in `app/views/gallery`

## Rails views usage

```ruby
class PropertiesController < ApplicationController
  def show
    @property = property
  end

  protected

  def property
    Hashie::Mash.new  title: 'A beautiful property', 
                      description: decription,
                      photos: photos
  end

  def description
    %q{Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent mauris arcu, auctor ac rhoncus non,  libero. Nulla dolor velit, volutpat a bibendum ut, hendrerit id mi. Pellentesque convallis erat in mi interdum rutrum. Phasellus interdum velit nulla.
    }
  end  

  def photos
    @photos ||= RGallery::Photos.new nil, photo_class: Property::Photo
    5.times do
      @photos.pages << 6.times.map {|n| (Kernel.rand(7) + 1).to_s }
    end
    @photos
  end
end
```

The RGallery should now also support multiple photo sources for responsive galleries:

```ruby
@photos.pages.add_photo_w_sources 'banner' => [{src: 'banner-HD', sizing: '2x'}, {src: 'banner-phone', sizing: '100w'}]

Note: See module `RGallery::Pages` class.

# OR

@photos.pages.add_photo_sources 'banner' => [{src: 'banner-HD', sizing: '2x'}], 'logo' => [{src: 'logo-HD', sizing: '2x'}

# OR on individual pages

@photos.page(:first).add_photo_sources 'banner' => [{src: 'banner-HD', sizing: '2x'}], 'logo' => [{src: 'logo-HD', sizing: '2x'}

```

This engine comes with a RGallery::Photos` model which can encapsulate your photos for display and allows you to group photos in multiple pages.
The `RGallery::Photo` class is a base class for describing a photo. 

You should create your own Photo class that inherits from `RGallery::Photo` (or implements the API), which knows how to render and describe your photos.

Here is a rough example:

```ruby
class Property
  class Photo < RGallery::Photo
    def path
      File.join folder, super
    end

    # mogrify -path fullpathto/temp2 -resize 60x60% -quality 60 -format jpg *.png

    # this will take all png files in your current directory (temp), 
    # resize to 60% (of largest dimension and keep aspect ratio), 
    # set jpg quality to 60 and convert to jpg.
    def thumb
      File.join folder, 'thumbs', file_path
    end

    def folder
      'gallery/images'
    end

    # Here we expect to create each photo with the 
    # id being set to a Property object
    def property
      id
    end

    # The filename of the picture. 
    # Here it assumes that the id assigned is a Property object, which has a 
    # method 'picture' which returns the picture id.
    def filename
      "property-#{property.picture}"
    end    

    def title
      property.title
    end

    def alt
      title
    end
    
    def self.extension
      :jpg
    end
  end
end
```

See the `lib/rails-gallery/rgallery/photos.rb` for details on how to extend this class appropriately to fit your scenario.

*debugging*

In order to help debug the configuration of the photo class, you can use the view_helper methods:

```ruby
= validate_gallery_photo photo # prints error msg if invalid
- validate_gallery_photo! photo # raise error if invalid
```

Or you can include the `RailsGallery::PhotoValidation` module anywhere you want to leverage these methods!

Then in your `properties/show.html.haml`:

*Responsive Gallery*

```haml
= render partial: 'gallery/template/responsive'
= render partial: 'gallery/responsive', locals: { photos: @property.photos }
```

Note :Currently only the *responsive* gallery uses a template, and thus requires rendering an extra partial.

*Slideshow Gallery*

```haml
= render partial: 'gallery/slideshow', locals: { photos: @property.photos }
```

*Galleria*

```haml
= render partial: 'gallery/galleria', locals: { photos: @property.photos }
```

All galleries should follow this convention (or as close as possible)

## Labels

Note that all gallery labels are rendered using Rails I18n `I18n.t`.
You should include appropriate translations for the following keys under 'rgallery':

* previous
* next
* photos_loading

The engine includes a `config/locales/rails_gallery.yml` file, currently only with english translation mappings. Include a `config/locales/rails_gallery.yml` file in your Rails app and override or supply you additional translation mappings ;)

## View helpers

There are also some view helpers included in `rails-gallery/view_helper.rb`

`= gallery_image type, photo`

*Simple example:*

Iterate all photos as a "single page".

```haml
- photos.all.each do |photo|
  = gallery_image :responsive, photo`
```

*Pages example:*

Iterate photos, one page at a time.

```haml
- photos.pages.each do |photo|
  = gallery_image :responsive, photo`
```

*Advanced example:*

Iterate photos, first page visible, then remaining pages invisible.

```haml
.page.visible
  - photos.page(:first).photos.each do |photo|
    = gallery_image :responsive, photo`

- photos.pages.remainder.each do |page|
  .page.hidden
    - page.photos.each do |photo|
      = gallery_image :responsive, photo`
```

### Shortcuts for view helpers

```haml
# galleria
= riagal_image photo
= riagal_imageset photo

# slideshow
= slidegal_image photo
= slidegal_imageset photo

# responsive
= respgal_image photo
= respgal_imageset photo

# touchtouch
= touchgal_image photo
= touchgal_imageset photo
```

## Responsive images via "image srcset"

The View Helpers also includes tag helpers to create image tags with [srcset](https://github.com/borismus/srcset-polyfill). This can be installed and used with [picturefill-rails](https://github.com/kristianmandrup/picturefill-rails)

Example:

```haml
- photos.pages.each do |photo|
  = gallery_imageset :responsive, photo`
```

Enjoy!

## Adding more galleries

Simply follow the existing conventions (see the code).

*ViewHelpers*

 Add the gallery name to the `#galleries` class method of the `ViewHelper` and create a module for that gallery with a `[name]_gallery_image(photo)` method.

Then add gallery client-side pieces to the assets folder following conventions and make sure that your css files (and possible js files) references the icons used (and any other asset) correctly  using `/assets/` in the path ;)

## TODO

Would be nice to allow pages/albums to have info assigned, such as title and/or description, tags etc.

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

