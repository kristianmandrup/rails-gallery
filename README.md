# Photo Gallery components for Rails

Popular Javascript Photo galleries/carousels ready to use with Rails 3+.

## Usage

`gem 'rails-gallery'

## Galleries included

* slideshow
* responsive
* galleria

Please add more using a similar convention as is used for these galleries ;)

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

This engine comes with a RGallery::Photos` model which can encapsulate your photos for display and allows you to group photos in multiple pages.
The `RGallery::Photo` class is a base class for describing a photo. 

You should create your own Photo class that inherits from `RGallery::Photo` (or implements the API), which knows how to render and describe your photos.

Here a rough example:

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
      'responsive-gallery/images'
    end

    def title
      'property title'
    end

    def alt
      'property alt'
    end
    
    def self.extension
      :jpg
    end
  end
end
```

See the `lib/rails-gallery/rgallery/photos.rb

Then in your `properties/show.html.haml`:

```haml
render partial: 'gallery/responsive', locals: { photos: @property.photos }
```

And so on...

## View helpers

There are also some view helpers included in `rails-gallery/view_helper.rb`

`gallery_image type, photo`

Simple example:

Iterate all photos as a "single page".

```haml
- photos.all.each do |photo|
  = gallery_image :responsive, photo`
```

Pages example:

Iterate photos, one page at a time.

```haml
- photos.pages.each do |photo|
  = gallery_image :responsive, photo`
```

Advanced example:

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

Enjoy!

## TODO

Would perhaps be nice to allow pages/albums to have info assigned, such as title and/or description, tags etc. ?

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

