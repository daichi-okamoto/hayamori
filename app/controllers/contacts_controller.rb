class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      flash[:success] = 'お問い合わせを送信しました'
      redirect_to new_contact_path
    else
      flash[:danger] = 'お問い合わせを送信できませんでした'
      @contact = Contact.new
      render :new
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
