require 'spec_helper'

class NoPathPhoto < RGallery::Photo
  def path
    nil
  end
end

class BadFilenamePhoto < RGallery::Photo
  def title
    'my title'
  end

  # blip method unknown!
  def filename
    blip
  end
end

class NoTitlePhoto < RGallery::Photo
  def path
    'abc'
  end

  def title
    nil
  end
end

class ValidPhoto < RGallery::Photo
  def path
    'abc'
  end

  def title
    'sdgds'
  end
end

describe RailsGallery::ConfigurationError do
  specify { RailsGallery::ConfigurationError.new.should be_a StandardError }
end

describe RailsGallery::ViewHelper do
  include ControllerTestHelpers,  
          RailsGallery::ViewHelper
  
  let(:no_path_photo)       { NoPathPhoto.new 1 }
  let(:no_title_photo)      { NoTitlePhoto.new 2 }
  let(:bad_filename_photo)  { BadFilenamePhoto.new 2 }
  let(:valid_photo)         { ValidPhoto.new 2 }

  describe 'validate_gallery_photo! photo' do          
    it 'should raise error on nil' do
      expect { validate_gallery_photo!(nil) }.to raise_error(ArgumentError)        
    end

    it 'should raise error on no #path method' do
      expect { validate_gallery_photo!(no_path_photo) }.to raise_error(ArgumentError)
    end

    it 'should raise error on no #title method' do
      expect { validate_gallery_photo!(no_title_photo) }.to raise_error(ArgumentError)
    end

    it 'should raise error on bad filename method' do
      expect { validate_gallery_photo!(bad_filename_photo) }.to raise_error(::RailsGallery::ConfigurationError)
    end
  end

  describe 'validate_gallery_photo photo' do          
    it 'should return nil error msg' do
      validate_gallery_photo(nil).should == "Photo must be a kind of RGallery::Photo, was: "
    end

    it 'should return no path error msg' do
      validate_gallery_photo(no_path_photo).should match /Photo must have a path:/
    end

    it 'should return no title error msg' do
      validate_gallery_photo(no_title_photo).should match /Photo must have a title:/
    end

    it 'should return bad filename method error' do
      validate_gallery_photo(bad_filename_photo).should match /filename or file_path could not be resolved for:/
    end
  end

  describe 'gallery_image photo' do          
    it 'should raise error on nil' do
      expect { gallery_image(nil) }.to raise_error(ArgumentError)
    end

    it 'should return error if valid type but nil photo' do
      expect { gallery_image(:galleria, nil) }.to raise_error(ArgumentError)
    end

    it 'should return error if invalid type and valid photo' do
      expect { gallery_image(:invalid, valid_photo) }.to raise_error(ArgumentError)
    end

    it "should no raise error for galleria image" do
      expect { gallery_image(:galleria, valid_photo) }.to_not raise_error
    end

    it "should render the image for galleria image" do
      gallery_image(:galleria, valid_photo).should == "<a href=\"abc\"><img data-description=\"no description\" data-title=\"sdgds\" src=\"abc\"></img></a>"
    end

    %w{slideshow responsive}.each do |gallery_type|
      it "should not raise error for type: #{gallery_type}" do
        expect { gallery_image(gallery_type, valid_photo) }.to_not raise_error
      end

      it "should render the image for galleria image" do
        gallery_image(gallery_type, valid_photo).should match /img.*alt=.*src="\w+"/
      end
    end
  end
end