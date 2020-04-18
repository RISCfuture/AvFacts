describe('listener', () => {
  beforeEach(() => cy.request('/cypress_rails_reset_state'))

  it('should be able to play a published episode', () => {
    cy.visit('/')
    cy.dataCy('episode').should('have.length', 1)
    cy.dataCy('episodeTitle').first().should('contain', 'Published')
    // cy.dataCy('episode-image').should('exist')

    cy.dataCy('player').should('not.exist')
    cy.dataCy('playButton').click()
    cy.dataCy('player').should('exist')
  })

  it('should not see a the Log Out link', () => {
    cy.visit('/')
    cy.dataCy('logout').should('not.exist')
  })
})
