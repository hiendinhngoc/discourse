# creates post actions based on a post and a user
class PostActionCreator

  def initialize(user, post)
    @user = user
    @post = post
  end

  def perform(action)
    guardian.ensure_post_can_act!(@post, PostActionType.types[action], opts: {
      taken_actions: PostAction.counts_for([@post].compact, @user)[@post&.id]
    })

    PostAction.act(@user, @post, action)
  end

  private

  def guardian
    @guardian ||= Guardian.new(@user)
  end

end
