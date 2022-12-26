class QuestionsController < ApplicationController
  before_action :set_question, only: %i[update destroy show edit hide]

  def new
    @user = User.find(params[:user_id])
    @question = Question.new(user: @user)
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to user_path(@question.user), notice: 'Новый вопрос создан!'
    else
      flash[:alert] = 'Не удалось создать вопрос!'
      render :new
    end
  end

  def edit
  end

  def update
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
  end

  def index
    @question = Question.new
    @questions = Question.all
  end

  def hide
    @question.update(hidden: true)

    redirect_back_or_to(root_path)
  end

  private

  def question_params
    params.require(:question).permit(:body, :user_id)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
