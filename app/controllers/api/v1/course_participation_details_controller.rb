class Api::V1::CourseParticipationDetailsController < ApplicationController
  # before_action :verify_current_user_to_be_employee, only: [:update]
  before_action :set_school
  before_action :set_owning_record, only: :index
  before_action :set_course, only: :create
  before_action :set_student_driving_school, only: :create
  # before_action :set_course_participation, only: [:update, :show]

  def index
    authorize @owning_record, policy_class: CourseParticipationDetailPolicy
    @course_participation_details = @owning_record.course_participation_details
                                                  .includes(course: :course_type, student_driving_school: :student)
                                                  .page(params[:page])
                                                  .per(records_per_page)
  end

  # def update
  #   authorize @driving_school, :can_manage_students?
  #
  #   if @course_participation.update(course_participation_params)
  #     create_activity
  #     render @course_participation
  #   else
  #     render json: @course_participation.errors, status: :unprocessable_entity
  #   end
  # end


  # POST api/v1/driving_schools/:driving_school_id/courses/:course_id/students/:student_id/course_participation_details
  def create
    authorize @school, :can_manage_students?

    @course_participation_detail = CourseParticipationDetail.create!(
      course_participation_params.merge(
        { course_id: @course.id, student_driving_school_id: @student_driving_school.id }
      )
    )
  end

  private
  #
  def course_participation_params
    params.require(:course_participation_detail).permit(:available_hours)
  end

  def set_school
    # Find me school requested by current user which is within her set of legally assigned active schools
    @school = current_user.user_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end

  def set_owning_record
    @owning_record = if params[:student_id].present?
      set_student_driving_school
    elsif params[:course_id].present?
      set_course
    end
  end

  def set_course
    @course = @school.courses.find(params[:course_id])
  end

  def set_student_driving_school
    @student_driving_school = @school.student_driving_schools.find_by!(student_id: params[:student_id])
  end

  # def set_student_school
  #   @student_school = @driving_school.student_driving_schools.active.find_by(student_id: params[:student_id]) if params[:student_id].present?
  # end
  #
  # def set_course
  #   @course = @driving_school.courses.find_by(id: params[:course_id]) if params[:course_id].present?
  # end
  #
  # def set_course_participation
  #   @course_participation = @student_school.course_participations.find(params[:id])
  # end
  #
  # def create_activity
  #   Activity.create(
  #     user: current_user,
  #     driving_school: @driving_school,
  #     activity_type: :driving_course_changed,
  #     target: @course_participation
  #   )
  # end
end
