class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :status, :author

  def author
    user = self.object.user
    {
      name: user.name,
      email: user.email,
      id: user.id
    }
  end
end
