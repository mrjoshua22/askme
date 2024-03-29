class QuestionsController < ApplicationController
  before_action :ensure_current_user, only: %i[edit update destroy hide]
  before_action :set_question_for_current_user, only: %i[edit update destroy hide]

  def new
    @user = User.find(params[:user_id])
    @question = Question.new(user: @user)
  end

  def create
    question_params = params.require(:question).permit(:body, :user_id)

    @question = Question.new(question_params)
    @question.author = current_user

    @user = User.find(question_params[:user_id])

    if check_captcha(@question) && @question.save
      redirect_to user_path(@question.user), notice: 'Новый вопрос создан!'
    else
      flash[:alert] = 'Не удалось создать вопрос!'

      render :new
    end
  end

  def edit
  end

  def update
    question_params = params.require(:question).permit(:body, :answer)

    if @question.update(question_params)
      redirect_to user_path(@question.user), notice: 'Сохранили вопрос!'
    else
      flash.now[:alert] = 'Не удалось обновить вопрос!'

      render :edit
    end
  end

  def destroy
    @user = @question.user
    @question.destroy

    redirect_to user_path(@user), notice: 'Вопрос удалён!'
  end

  def show
    @question = Question.find(params[:id])
  end

  def index
    @questions = Question.order(created_at: :desc).first(10)
    @users = User.order(created_at: :desc).first(10)
    @hashtags =
      Hashtag.joins(:questions).uniq
  end

  def hide
    @question.update(hidden: true)

    redirect_back_or_to(root_path)
  end

  private

  def check_captcha(model)
    if current_user.present?
      true
    else
      verify_recaptcha(model: model)
    end
  end

  def set_question_for_current_user
    @question = current_user.questions.find(params[:id])
  end
end
