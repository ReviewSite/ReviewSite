class Review::Question
  attr_accessor :heading, :title, :fields, :description, :scale_field

  def initialize(heading, title, fields, description, scale_field = nil)
    @heading = heading
    @title = title
    @fields = fields
    @description = description
    @scale_field = scale_field
  end
end