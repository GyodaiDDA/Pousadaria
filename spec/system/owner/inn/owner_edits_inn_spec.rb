require 'rails_helper'

describe '::Owner altera os dados da pousada' do
  before(:each) do
    owner = Owner.create(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', user_type: 'Owner')
    Inn.create(brand_name: 'Pousada Recanto do Sossego',
               legal_name: 'Recanto do Sossego Hospedagens LTDA',
               vat_number: '12345678000911',
               postal_code: '13200-000',
               user_id: owner.id)
    login_as(owner)
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Editar'
  end

  it 'com sucesso' do
    # Arrange
    # Act
    fill_in 'Endereço', with: 'Rua das Lavadeiras S/N'
    uncheck 'Ativa?'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Sua pousada foi atualizada com sucesso!')
  end

  it 'e falha por validação de cpnj' do
    # Arrange
    # Act
    fill_in 'CNPJ', with: '1234567800911'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Não foi possível atualizar a pousada.')
  end
end
