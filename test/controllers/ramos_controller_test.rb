require "test_helper"

class RamosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ramo = ramos(:one)
  end

  test "should get index" do
    get ramos_url
    assert_response :success
  end

  test "should get new" do
    get new_ramo_url
    assert_response :success
  end

  test "should create ramo" do
    assert_difference("Ramo.count") do
      post ramos_url, params: { ramo: { conect_liga: @ramo.conect_liga, creditos: @ramo.creditos, curso: @ramo.curso, lista_cruzada: @ramo.lista_cruzada, materia: @ramo.materia, name: @ramo.name, plan_estudios: @ramo.plan_estudios, profesor: @ramo.profesor, seccion: @ramo.seccion } }
    end

    assert_redirected_to ramo_url(Ramo.last)
  end

  test "should show ramo" do
    get ramo_url(@ramo)
    assert_response :success
  end

  test "should get edit" do
    get edit_ramo_url(@ramo)
    assert_response :success
  end

  test "should update ramo" do
    patch ramo_url(@ramo), params: { ramo: { conect_liga: @ramo.conect_liga, creditos: @ramo.creditos, curso: @ramo.curso, lista_cruzada: @ramo.lista_cruzada, materia: @ramo.materia, name: @ramo.name, plan_estudios: @ramo.plan_estudios, profesor: @ramo.profesor, seccion: @ramo.seccion } }
    assert_redirected_to ramo_url(@ramo)
  end

  test "should destroy ramo" do
    assert_difference("Ramo.count", -1) do
      delete ramo_url(@ramo)
    end

    assert_redirected_to ramos_url
  end
end
