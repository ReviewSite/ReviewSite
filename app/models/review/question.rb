class Review::Question
  attr_accessor :heading, :title, :fields, :description, :scale_field

  def initialize(heading, title, fields, description)
    @heading = heading
    @title = title
    @fields = fields
    @description = description
  end
end