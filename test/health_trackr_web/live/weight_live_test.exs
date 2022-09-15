defmodule HealthTrackrWeb.WeightLiveTest do
  use HealthTrackrWeb.ConnCase

  import Phoenix.LiveViewTest
  import HealthTrackr.WeightsFixtures

  @create_attrs %{date: %{day: 11, month: 9, year: 2022}, weight: 120.5}
  @update_attrs %{date: %{day: 12, month: 9, year: 2022}, weight: 456.7}
  @invalid_attrs %{date: %{day: 30, month: 2, year: 2022}, weight: nil}

  defp create_weight(_) do
    weight = weight_fixture()
    %{weight: weight}
  end

  describe "Index" do
    setup [:create_weight]

    test "lists all weights", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Listing Weights"
    end

    test "saves new weight", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.weight_index_path(conn, :index))

      assert index_live |> element("a", "New Weight") |> render_click() =~
               "New Weight"

      assert_patch(index_live, Routes.weight_index_path(conn, :new))

      assert index_live
             |> form("#weight-form", weight: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#weight-form", weight: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Weight created successfully"
    end

    test "updates weight in listing", %{conn: conn, weight: weight} do
      {:ok, index_live, _html} = live(conn, Routes.weight_index_path(conn, :index))

      assert index_live |> element("#weight-#{weight.id} a", "Edit") |> render_click() =~
               "Edit Weight"

      assert_patch(index_live, Routes.weight_index_path(conn, :edit, weight))

      assert index_live
             |> form("#weight-form", weight: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#weight-form", weight: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Weight updated successfully"
    end

    test "deletes weight in listing", %{conn: conn, weight: weight} do
      {:ok, index_live, _html} = live(conn, Routes.weight_index_path(conn, :index))

      assert index_live |> element("#weight-#{weight.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#weight-#{weight.id}")
    end
  end

  describe "Show" do
    setup [:create_weight]

    test "displays weight", %{conn: conn, weight: weight} do
      {:ok, _show_live, html} = live(conn, Routes.weight_show_path(conn, :show, weight))

      assert html =~ "Show Weight"
    end

    test "updates weight within modal", %{conn: conn, weight: weight} do
      {:ok, show_live, _html} = live(conn, Routes.weight_show_path(conn, :show, weight))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Weight"

      assert_patch(show_live, Routes.weight_show_path(conn, :edit, weight))

      assert show_live
             |> form("#weight-form", weight: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#weight-form", weight: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.weight_show_path(conn, :show, weight))

      assert html =~ "Weight updated successfully"
    end
  end
end
