defmodule HealthTrackrWeb.WeightLiveTest do
  use HealthTrackrWeb.ConnCase

  import Phoenix.LiveViewTest
  import HealthTrackr.WeightsFixtures

  @create_attrs %{date: ~D[2022-09-22], weight: 99}
  @update_attrs %{date: ~D[2022-09-22], weight: 88}
  @invalid_attrs %{date: nil, weight: nil}

  defp create_weight(_) do
    weight = weight_fixture()
    %{weight: weight}
  end

  defp create_iweight(weight) do
    {:ok, weight} =
      HealthTrackr.Weights.create_weight(%{
        date: ~D[2022-09-22],
        weight: weight
      })

    weight
  end

  defp weight_row(weight), do: "#weight-#{weight.id}"

  describe "Index" do
    setup [:create_weight]

    test "lists all weights", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Listing Weights"
    end

    test "saves new weight", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.weight_index_path(conn, :index))

      assert index_live
             |> element("a", "New Weight")
             |> render_click() =~ "New Weight"

      assert_patch(index_live, Routes.weight_index_path(conn, :new))

      assert index_live
             |> form("#weight-form", weight: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

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
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#weight-form", %{weight: @update_attrs})
        |> render_submit()
        |> follow_redirect(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Weight updated successfully"
    end

    test "deletes weight in listing", %{conn: conn, weight: weight} do
      create_iweight(44.4)

      {:ok, index_live, _html} = live(conn, Routes.weight_index_path(conn, :index))

      assert index_live |> element("#weight-#{weight.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#weight-#{weight.id}")
    end
  end

  describe "Pagination" do
    test "paginates using the options in the URL", %{conn: conn} do
      a = create_iweight(44.4)
      b = create_iweight(55.5)

      {:ok, view, _html} = live(conn, "/weights?page=1&per_page=1")

      assert has_element?(view, weight_row(a))
      refute has_element?(view, weight_row(b))

      {:ok, view, _html} = live(conn, "/weights?page=2&per_page=1")

      refute has_element?(view, weight_row(a))
      assert has_element?(view, weight_row(b))

      {:ok, view, _html} = live(conn, "/weights?page=1&per_page=2")

      assert has_element?(view, weight_row(a))
      assert has_element?(view, weight_row(b))
    end

    test "clicking next, previous, and page links patch the URL", %{conn: conn} do
      _a = create_iweight(88.8)
      _b = create_iweight(80.1)
      _c = create_iweight(79.4)

      {:ok, view, _html} = live(conn, "/weights?page=1&per_page=1")

      view
      |> element("a", "Next")
      |> render_click()

      assert_patched(view, "/weights?page=2&per_page=1")

      view
      |> element("a", "Previous")
      |> render_click()

      assert_patched(view, "/weights?page=1&per_page=1")

      view
      |> element("a", "2")
      |> render_click()

      assert_patched(view, "/weights?page=2&per_page=1")
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
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#weight-form", weight: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.weight_show_path(conn, :show, weight))

      assert html =~ "Weight updated successfully"
    end
  end
end
