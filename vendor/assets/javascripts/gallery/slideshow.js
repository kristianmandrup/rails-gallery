$(function() {
  /**
  * interval : time between the display of images
  * playtime : the timeout for the setInterval function
  * current  : number to control the current image
  * current_thumb : the index of the current thumbs wrapper
  * nmb_thumb_wrappers : total number of thumbs wrappers
  * nmb_images_wrapper : the number of images inside of each wrapper
  */
  var interval      = 4000;
  var playtime;
  var current       = 0;
  var current_thumb     = 0;
  var nmb_thumb_wrappers  = $('#msg_thumbs .msg_thumb_wrapper').length;
  var nmb_images_wrapper  = 6;
  /**
  * start the slideshow
  */
  play();
  
  /**
  * show the controls when 
  * mouseover the main container
  */
  slideshowMouseEvent();
  function slideshowMouseEvent(){
    $('#msg_slideshow').unbind('mouseenter')
               .bind('mouseenter',showControls)
               .andSelf()
               .unbind('mouseleave')
               .bind('mouseleave',hideControls);
    }
  
  /**
  * clicking the grid icon,
  * shows the thumbs view, pauses the slideshow, and hides the controls
  */
  $('#msg_grid').bind('click',function(e){
    hideControls();
    $('#msg_slideshow').unbind('mouseenter').unbind('mouseleave');
    pause();
    $('#msg_thumbs').stop().animate({'top':'0px'},500);
    e.preventDefault();
  });
  
  /**
  * closing the thumbs view,
  * shows the controls
  */
  $('#msg_thumb_close').bind('click',function(e){
    showControls();
    slideshowMouseEvent();
    $('#msg_thumbs').stop().animate({'top':'-230px'},500);
    e.preventDefault();
  });
  
  /**
  * pause or play icons
  */
  $('#msg_pause_play').bind('click',function(e){
    var $this = $(this);
    if($this.hasClass('msg_play'))
      play();
    else
      pause();
    e.preventDefault(); 
  });
  
  /**
  * click controls next or prev,
  * pauses the slideshow, 
  * and displays the next or prevoius image
  */
  $('#msg_next').bind('click',function(e){
    pause();
    next();
    e.preventDefault();
  });
  $('#msg_prev').bind('click',function(e){
    pause();
    prev();
    e.preventDefault();
  });
  
  /**
  * show and hide controls functions
  */
  function showControls(){
    $('#msg_controls').stop().animate({'right':'15px'},500);
  }
  function hideControls(){
    $('#msg_controls').stop().animate({'right':'-110px'},500);
  }
  
  /**
  * start the slideshow
  */
  function play(){
    next();
    $('#msg_pause_play').addClass('msg_pause').removeClass('msg_play');
    playtime = setInterval(next,interval)
  }
  
  /**
  * stops the slideshow
  */
  function pause(){
    $('#msg_pause_play').addClass('msg_play').removeClass('msg_pause');
    clearTimeout(playtime);
  }
  
  /**
  * show the next image
  */
  function next(){
    ++current;
    showImage('r');
  }
  
  /**
  * shows the previous image
  */
  function prev(){
    --current;
    showImage('l');
  }
  
  /**
  * shows an image
  * dir : right or left
  */
  function showImage(dir){
    /**
    * the thumbs wrapper being shown, is always 
    * the one containing the current image
    */
    alternateThumbs();
    
    /**
    * the thumb that will be displayed in full mode
    */
    var $thumb = $('#msg_thumbs .msg_thumb_wrapper:nth-child('+current_thumb+')')
          .find('a:nth-child('+ parseInt(current - nmb_images_wrapper*(current_thumb -1)) +')')
          .find('img');
    if($thumb.length){
      var source = $thumb.attr('alt');
      var $currentImage = $('#msg_wrapper').find('img');
      if($currentImage.length){
        // console.log('image src:', source);
        $currentImage.fadeOut(function(){
          $(this).remove();
          $('<img />').load(function(){
            var $image = $(this);
            resize($image);
            $image.hide();
            $('#msg_wrapper').empty().append($image.fadeIn());
          }).attr('src',source);
        });
      }
      else{
        $('<img />').load(function(){
            var $image = $(this);
            resize($image);
            $image.hide();
            // console.log('resize image src:', source);
            $('#msg_wrapper').empty().append($image.fadeIn());
        }).attr('src',source);
      }
          
    }
    else{ //this is actually not necessary since we have a circular slideshow
      if(dir == 'r')
        --current;
      else if(dir == 'l')
        ++current;  
      alternateThumbs();
      return;
    }
  }
  
  /**
  * the thumbs wrapper being shown, is always 
  * the one containing the current image
  */
  function alternateThumbs(){
    $('#msg_thumbs').find('.msg_thumb_wrapper:nth-child('+current_thumb+')')
            .hide();
    current_thumb = Math.ceil(current/nmb_images_wrapper);
    /**
    * if we reach the end, start from the beggining
    */
    if(current_thumb > nmb_thumb_wrappers){
      current_thumb   = 1;
      current     = 1;
    } 
    /**
    * if we are at the beggining, go to the end
    */          
    else if(current_thumb == 0){
      current_thumb   = nmb_thumb_wrappers;
      current     = current_thumb*nmb_images_wrapper;
    }
    
    $('#msg_thumbs').find('.msg_thumb_wrapper:nth-child('+current_thumb+')')
            .show();  
  }
  
  /**
  * click next or previous on the thumbs wrapper
  */
  $('#msg_thumb_next').bind('click',function(e){
    next_thumb();
    e.preventDefault();
  });
  $('#msg_thumb_prev').bind('click',function(e){
    prev_thumb();
    e.preventDefault();
  });
  function next_thumb(){
    var $next_wrapper = $('#msg_thumbs').find('.msg_thumb_wrapper:nth-child('+parseInt(current_thumb+1)+')');
    if($next_wrapper.length){
      $('#msg_thumbs').find('.msg_thumb_wrapper:nth-child('+current_thumb+')')
              .fadeOut(function(){
                ++current_thumb;
                $next_wrapper.fadeIn();                 
              });
    }
  }
  function prev_thumb(){
    var $prev_wrapper = $('#msg_thumbs').find('.msg_thumb_wrapper:nth-child('+parseInt(current_thumb-1)+')');
    if($prev_wrapper.length){
      $('#msg_thumbs').find('.msg_thumb_wrapper:nth-child('+current_thumb+')')
              .fadeOut(function(){
                --current_thumb;
                $prev_wrapper.fadeIn();                 
              });
    }       
  }
  
  /**
  * clicking on a thumb, displays the image (alt attribute of the thumb)
  */
  $('#msg_thumbs .msg_thumb_wrapper > a').bind('click',function(e){
    var $this     = $(this);
    $('#msg_thumb_close').trigger('click');
    var idx     = $this.index();
    var p_idx   = $this.parent().index();
    current     = parseInt(p_idx*nmb_images_wrapper + idx + 1);
    showImage();
    e.preventDefault();
  }).bind('mouseenter',function(){
    var $this     = $(this);
    $this.stop().animate({'opacity':1});
  }).bind('mouseleave',function(){
    var $this     = $(this);  
    $this.stop().animate({'opacity':0.5});
  });
  
  /**
  * resize the image to fit in the container (400 x 400)
  */
  function resize($image){
    var theImage  = new Image();
    theImage.src  = $image.attr("src");
    var imgwidth  = theImage.width;
    var imgheight   = theImage.height;
    
    var containerwidth  = 400;
    var containerheight = 400;
          
    if(imgwidth > containerwidth){
      var newwidth = containerwidth;
      var ratio = imgwidth / containerwidth;
      var newheight = imgheight / ratio;
      if(newheight > containerheight){
        var newnewheight = containerheight;
        var newratio = newheight/containerheight;
        var newnewwidth =newwidth/newratio;
        theImage.width = newnewwidth;
        theImage.height= newnewheight;
      }
      else{
        theImage.width = newwidth;
        theImage.height= newheight;
      }
    }
    else if(imgheight > containerheight){
      var newheight = containerheight;
      var ratio = imgheight / containerheight;
      var newwidth = imgwidth / ratio;
      if(newwidth > containerwidth){
        var newnewwidth = containerwidth;
        var newratio = newwidth/containerwidth;
        var newnewheight =newheight/newratio;
        theImage.height = newnewheight;
        theImage.width= newnewwidth;
      }
      else{
        theImage.width = newwidth;
        theImage.height= newheight;
      }
    }
    $image.css({
      'width' :theImage.width,
      'height':theImage.height
    });
  }
});