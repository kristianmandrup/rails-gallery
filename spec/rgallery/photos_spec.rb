require 'spec_helper'
require 'rgallery/property_photo'

describe RGallery::Photos do
  context 'New empty RGallery::Photos collection' do
    subject { RGallery::Photos.new }

    its(:pages) { should be_empty }
    its(:pages) { should be_a RGallery::Pages }

    describe '.page :first' do
      specify { subject.page(:first).should be_empty }
    end

    describe '.page :remainder' do
      specify { subject.pages.remainder.should be_empty }
    end
  end

  context 'Photos with one page' do
    subject { RGallery::Photos.new ['0'] }

    its(:pages) { should_not be_empty }
    its(:pages) { should be_a RGallery::Pages }

    describe '.page' do
      describe ':first' do
        specify { subject.page(:first).should_not be_empty }
      end

      describe ':remainder' do
        specify { subject.pages.remainder.should be_empty }
      end
    end

    describe '.all' do
      specify { subject.all.first.should be_a RGallery::Photo }      

      specify { subject.all.first.id.should == '0' }            

      specify { subject.all.first.path.should == '0.png' }            
    end
  end

  context 'configure with custom Photo class' do
    subject { RGallery::Photos.new ['0'], photo_class: Property::Photo }

    specify { subject.all.first.should be_a Property::Photo }            
  end
end