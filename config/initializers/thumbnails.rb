# Adds a {#thumbnail} method to `ActiveStorage::Blob` that generates a scaled,
# cropped image.

module AddThumbnailToBlob

  # Generates a scaled, cropped thumbnail image. The image will be exactly the
  # dimensions given, and will be scaled to fill then center-cropped.
  #
  # @param [Integer] new_width The thumbnail width.
  # @param [Integer] new_height The thumbnail height.
  # @return [ActiveStorage::Variant] An image variant with the appropriate
  #   scaling and cropping applied.

  def thumbnail(new_width, new_height=new_width)
    width  = metadata['width']
    height = metadata['height']

    width_scale_factor  = new_width.to_f / width
    height_scale_factor = new_height.to_f / height

    unless width_scale_factor > 1 || height_scale_factor > 1
      scale_width  = new_width
      scale_height = new_height
      crop_x       = 0
      crop_y       = 0

      if width_scale_factor > height_scale_factor
        scale_height = (height * width_scale_factor).to_i
        crop_y       = (scale_height - new_height) / 2
      else
        scale_width = (width * height_scale_factor).to_i
        crop_x      = (scale_width - new_width) / 2
      end

      return variant(thumbnail: "#{scale_width}x#{scale_height}",
                     crop:      "#{new_width}x#{new_height}+#{crop_x}+#{crop_y}")
    end

    return self
  end
end

Rails.application.config.to_prepare do
  ActiveStorage::Blob.include AddThumbnailToBlob
end
