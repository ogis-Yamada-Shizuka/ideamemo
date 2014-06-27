class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]
         

  #usernameを必須・一意とする
  validates_uniqueness_of :username
  validates_presence_of :username

  #usernameは８桁で、うち先頭の２文字は英字でなくてはならない
  validates :username , :length => { :is => 8 },
                        :format => { :with => /[A-Za-z]{2}[0-9]{6}/ }

  #usernameを利用してログインするようにオーバーライド
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      #認証の条件式を変更する
      where(conditions).where(["username = :value", { :value => username }]).first
    else
      where(conditions).first
    end
  end

  #登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end

end
