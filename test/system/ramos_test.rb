require "application_system_test_case"

class RamosTest < ApplicationSystemTestCase
  setup do
    @ramo = ramos(:one)
  end

  test "visiting the index" do
    visit ramos_url
    assert_selector "h1", text: "Ramos"
  end

  test "creating a Ramo" do
    visit ramos_url
    click_on "New Ramo"

    fill_in "Connector liga", with: @ramo.connector_liga
    fill_in "Creditos", with: @ramo.creditos
    fill_in "Curso", with: @ramo.curso
    fill_in "Lista cruzada", with: @ramo.lista_cruzada
    fill_in "Materia", with: @ramo.materia
    fill_in "Nombre", with: @ramo.nombre
    fill_in "Plan estudios", with: @ramo.plan_estudios
    fill_in "Profesor", with: @ramo.profesor
    fill_in "Seccion", with: @ramo.seccion
    click_on "Create Ramo"

    assert_text "Ramo was successfully created"
    click_on "Back"
  end

  test "updating a Ramo" do
    visit ramos_url
    click_on "Edit", match: :first

    fill_in "Connector liga", with: @ramo.connector_liga
    fill_in "Creditos", with: @ramo.creditos
    fill_in "Curso", with: @ramo.curso
    fill_in "Lista cruzada", with: @ramo.lista_cruzada
    fill_in "Materia", with: @ramo.materia
    fill_in "Nombre", with: @ramo.nombre
    fill_in "Plan estudios", with: @ramo.plan_estudios
    fill_in "Profesor", with: @ramo.profesor
    fill_in "Seccion", with: @ramo.seccion
    click_on "Update Ramo"

    assert_text "Ramo was successfully updated"
    click_on "Back"
  end

  test "destroying a Ramo" do
    visit ramos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ramo was successfully destroyed"
  end
end
