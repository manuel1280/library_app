json.status 'success'
json.data do
	json.id @book.id
	json.title @book.title
end
