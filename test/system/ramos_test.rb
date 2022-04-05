require "application_system_test_case"

class RamosTest < ApplicationSystemTestCase
  setup do
    @ramo = ramos(:one)
  end

  test "visiting the index" do
    visit ramos_url
    assert_selector "h1", text: "Ramos"
  end

  test "should create ramo" do
    visit ramos_url
    click_on "New ramo"

    fill_in "Conect liga", with: @ramo.conect_liga
    fill_in "Creditos", with: @ramo.creditos
    fill_in "Curso", with: @ramo.curso
    fill_in "Lista cruzada", with: @ramo.lista_cruzada
    fill_in "Materia", with: @ramo.materia
    fill_in "Name", with: @ramo.nombre
    fill_in "Nrc", with: @ramo.nrc
    fill_in "Plan estudios", with: @ramo.plan_estudios
    fill_in "Profesor", with: @ramo.profesor
    fill_in "Seccion", with: @ramo.seccion
    click_on "Create Ramo"

    assert_text "Ramo was successfully created"
    click_on "Back"
  end

  test "should update Ramo" do
    visit ramo_url(@ramo)
    click_on "Edit this ramo", match: :first

    fill_in "Conect liga", with: @ramo.conect_liga
    fill_in "Creditos", with: @ramo.creditos
    fill_in "Curso", with: @ramo.curso
    fill_in "Lista cruzada", with: @ramo.lista_cruzada
    fill_in "Materia", with: @ramo.materia
    fill_in "Name", with: @ramo.nombre
    fill_in "Nrc", with: @ramo.nrc
    fill_in "Plan estudios", with: @ramo.plan_estudios
    fill_in "Profesor", with: @ramo.profesor
    fill_in "Seccion", with: @ramo.seccion
    click_on "Update Ramo"

    assert_text "Ramo was successfully updated"
    click_on "Back"
  end

  test "should destroy Ramo" do
    visit ramo_url(@ramo)
    click_on "Destroy this ramo", match: :first

    assert_text "Ramo was successfully destroyed"
  end
end
