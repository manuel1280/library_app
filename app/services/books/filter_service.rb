module Books
	class FilterService

		def initialize(filter_params)
			@title = filter_params.fetch(:title, nil)
			@author = filter_params.fetch(:author, nil)
			@genre = filter_params.fetch(:genre, nil)
		end

		def call
			scoped = Book.all
			scoped = by_title(scoped) if @title.present?
			scoped = by_author(scoped) if @author.present?
			scoped = by_genre(scoped) if @genre.present?
			scoped
		end

		private

		def by_title(scoped)
			scoped.where('title LIKE ?', "%#{@title}%")
		end

		def by_author(scoped)
			scoped.where('author LIKE ?', "%#{@author}%")
		end

		def by_genre(scoped)
			scoped.where('genre LIKE ?', "%#{@genre}%")
		end
	end
end
