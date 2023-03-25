#  Copyright (c) 2023, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

app = window.App ||= {}

app.ProfileImageOverlay = {
  show: ->
    $('.profil-image-overlay').addClass('active')
  hide: ->
    $('.profil-image-overlay').removeClass('active') 
}

$(document).on 'click', '.profil-big', app.ProfileImageOverlay.show
$(document).on 'click', '.profil-image-overlay', app.ProfileImageOverlay.hide
