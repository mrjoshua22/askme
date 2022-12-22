class QuestionsController < ApplicationController
  before_action :set_question, only: %i[update destroy show edit hide]

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to question_path(@question), notice: 'Новый вопрос создан!'
    else
      flash[:alert] = 'Не удалось создать вопрос!'
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to question_path(@question), notice: 'Сохранили вопрос!'
    else
      flash.now[:alert] = 'Не удалось обновить вопрос!'
      render :edit
    end
  end

  def destroy
    @question.destroy

    redirect_to questions_path, notice: 'Вопрос удалён!'
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
