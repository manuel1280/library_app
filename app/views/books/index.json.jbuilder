json.status 'success'
json.data do
	json.array! @books do |book|
		json.id book.id
		json.title book.title
		json.author book.author
		json.genre book.genre
	end
end
