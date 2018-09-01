# A User is an admin user who has the capability to upload, edit, and delete
# episodes. Users are identified by username and authenticated by password,
# which is stored in a hashed form.
#
# Properties
# ----------
#
# |                   |                                                       |
# |:------------------|:------------------------------------------------------|
# | `username`        | A unique username for the user; used when logging in. |
# | `password_digest` | The user's password, hashed and encrypted.            |

class User < ApplicationRecord
  has_secure_password

  validates :username,
            presence:   true,
            uniqueness: true,
            length:     {maximum: 50}
end
