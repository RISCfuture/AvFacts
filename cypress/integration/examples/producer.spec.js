describe('producer', () => {
  beforeEach(() => cy.request('/cypress_rails_reset_state'))

  it('should not be able to log in with an invalid login', () => {
    cy.visit('/')
    cy.dataCy('login').click()
    cy.dataCy('usernameField').type('cypress')
    cy.dataCy('passwordField').type('wrong')
    cy.dataCy('logout').should('not.exist')
  })

  context('logged in', () => {
    beforeEach(() => {
      cy.visit('/')
      cy.dataCy('login').click()
      cy.dataCy('usernameField').type('cypress')
      cy.dataCy('passwordField').type('cypress')
      cy.dataCy('loginSubmit').click()
    })

    it('should be able to log in', () => {
      cy.dataCy('logout').should('exist')
    })

    it('should see all episodes', () => {
      cy.dataCy('episodeTitle').eq(3).should('contain', 'Published')
      cy.dataCy('episodeTitle').eq(2).should('contain', 'Unpublished')
      cy.dataCy('episodeTitle').eq(1).should('contain', 'Blocked')
      cy.dataCy('episodeTitle').eq(0).should('contain', 'Draft')
    })

    it('should be able to create a draft episode', () => {
      cy.dataCy('uploadNewLink').click()
      cy.dataCy('titleField').type('Test Draft')
      cy.dataCy('descriptionField').type("Test draft description")
      cy.dataCy('podcastSubmitButton').click()

      cy.dataCy('episodeTitle').eq(0).should('contain', 'Test Draft')
      cy.dataCy('episode').eq(0).get('playButton').should('not.exist')
    })

    // it('should be able to create and transcode new episode', () => {
    //   cy.dataCy('uploadNewLink').click()
    //   cy.dataCy('titleField').type('Test Published')
    //   cy.dataCy('descriptionField').type("Test published description")
    //   cy.dataCy('audioField').attachFile('audio.aif')
    //   cy.dataCy('imageField').attachFile('image.jpg')
    //
    //   cy.dataCy('podcastSubmitButton').click()
    //
    //   cy.dataCy('episodeTitle').eq(0).should('contain', 'Test Published')
    //   cy.dataCy('episode').eq(0).get('playButton').should('exist')
    // })

    it('should see errors if any fields are invalid', () => {
      cy.dataCy('uploadNewLink').click()
      cy.dataCy('titleField').type(' ')
      cy.dataCy('descriptionField').type("Test draft description")
      cy.dataCy('podcastSubmitButton').click()

      cy.dataCy('titleField').get('input').should('have.class', 'invalid')
    })
  })
});
