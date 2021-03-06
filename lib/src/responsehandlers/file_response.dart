part of route_provider;

class FileResponse extends ResponseHandler {
    String filename;

    FileResponse(this.filename) : super();

    String response(HttpRequest request, Map vars) {
        String fileName = this.filename;
        var file = new File(fileName);
        file.exists().then((exists){
            if(exists == true){
                String mimeType = mime(fileName);
                if (mimeType == null) mimeType = 'text/plain; charset=UTF-8';
                request.response.headers.add(HttpHeaders.CONTENT_TYPE, mimeType);

                StreamConsumer streamConsumer = request.response;
                file.openRead().pipe(streamConsumer).then((streamConsumer){
                    streamConsumer.close();
                });
            } else {
                request.response
                    ..statusCode = HttpStatus.NOT_FOUND
                    ..write('Not found')
                    ..close();
            }
        });
    }
}