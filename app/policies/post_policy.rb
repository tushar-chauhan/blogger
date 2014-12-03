class PostPolicy < Struct.new(:user, :post)
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    (user.admin? || user.writer?) && post.user == user
  end

  def edit?
    update?
  end

  def create?
    user.admin? || user.writer?
  end

  def new?
    create?
  end

  def me?
    create?
  end

  def destroy?
    user.admin? || (user.writer? && post.user == user)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin? || user.writer?
        scope.where(user_id: user.id)
      end
    end
  end

end
