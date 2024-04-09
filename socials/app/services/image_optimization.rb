# frozen_string_literal: true

# ImageOptimization
class ImageOptimization
  def initialize(image)
    @image = image
    @max_dimention = 1000
    @format = 'webp'
    @quality = 75
  end

  def max_dimention(value)
    @max_dimention = value

    self
  end

  def format(value)
    @format = value

    self
  end

  def quality(value)
    @quality = value

    self
  end

  def call
    width, height = Vips::Image.new_from_file(@image.path).size
    width, height = calculate_new_image_size_by_limit(width, height, @max_dimention)

    ImageProcessing::Vips
      .source(@image)
      .resize_to_fit(width, height)
      .convert(@format)
      .saver(quality: @quality)
      .call
  end

  def calculate_new_image_size_by_limit(width, height, limit)
    return [width, height] unless width > limit || height > limit

    if width > height
      height = (limit * height) / width
      width = limit
    else
      width = (limit * width) / height
      height = limit
    end

    [width, height]
  end
end
