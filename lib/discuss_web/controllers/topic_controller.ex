defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

   case Repo.insert(changeset) do
     {:ok, _topic} ->
      conn
      |> put_flash(:info, "Topic created!")
      |> redirect(to: Routes.topic_path(conn, :index))
     {:error, changeset} ->
      render conn, "new.html", changeset: changeset
      # conn
      # |> put_flash(:warning, "Topic cannot be blank!")
      # |> redirect(to: Routes.topic_path(conn, :new))
   end
  end

  def edit(conn, %{"id" => topic_id }) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully!")
        |> redirect(to: Routes.topic_path(conn, :index))
        {:error, changeset} ->
          render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end
end
