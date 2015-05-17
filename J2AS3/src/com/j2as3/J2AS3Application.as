package com.j2as3 {
    import flash.desktop.ClipboardFormats;
    import flash.events.Event;
    import flash.events.NativeDragEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import mx.controls.Button;
    import mx.controls.ProgressBar;
    import mx.controls.TextArea;
    import mx.core.WindowedApplication;
    import mx.managers.DragManager;

    public class J2AS3Application extends WindowedApplication {
        public var textArea:TextArea;
        public var outputButton:Button;
        public var inputButton:Button;
        public var progressBar:ProgressBar;
        [Bindable] public var outputDirSelected:Boolean = false;
        protected var _outputDir:File;
        [Bindable] protected var _outputDirName:String;
        [Bindable] protected var _inputDirName:String;
        
        public function J2AS3Application() {
            super();
        }
        
        override protected function createChildren():void{
            super.createChildren();
            outputButton.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onOutputDragEnter, false, 0.0, true);
            outputButton.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,  onOutputDragDrop,  false, 0.0, true);
            inputButton .addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onInputDragEnter,  false, 0.0, true);
            inputButton .addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,  onInputDragDrop,   false, 0.0, true);
        }
        
        private function onOutputDragEnter(event:NativeDragEvent):void {
            if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
                DragManager.acceptDragDrop(outputButton);                
        }
        
        private function onInputDragEnter(event:NativeDragEvent):void {
            if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
                DragManager.acceptDragDrop(inputButton);                
        }
        
        private function onOutputDragDrop(event:NativeDragEvent):void {
            if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
                var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
                if (files) {
                    outputDirSelected = true;
                    _outputDir = files[0];
                    _outputDirName = _outputDir.nativePath;
                } 
            }            
        } 
        
        private function onInputDragDrop( event : NativeDragEvent ):void {
            if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
                var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
                if (files)
                    doDirSelect(files[0]);
            }            
        } 
        
        public function doInput():void {
            var file:File = new File();
            file.addEventListener(Event.SELECT, onDirSelect, false, 0.0, true);
            file.browseForDirectory("Select Java Directory");         
        }
        
        public function doOutput():void {
            var file:File = new File();
            file.addEventListener(Event.SELECT, onOutSelect, false, 0.0, true);
            file.browseForDirectory("Select AS3 Directory");
        }
        
        private function onOutSelect(event:Event):void {
            outputDirSelected = true;
            _outputDir = event.target as File;            
        }
        
        private function onDirSelect(event:Event):void {
            var dir:File = event.target as File;
            doDirSelect(dir);
        }
        
        private function doDirSelect(dir:File):void {
        	progressBar.visible = true;
            textArea.text = "";
            _inputDirName = dir.nativePath;
            var arr:Array = dir.getDirectoryListing();
            var ind:Number = 0;
            progressBar.minimum = 0;
            progressBar.maximum = arr.length;
            for each (var file:File in arr) {
                progressBar.setProgress(ind++, arr.length);
                if (file.isDirectory)  // TODO recurse
                    continue;
                convertFile(file);                   
                textArea.text += file.name + "\n";
            }
            progressBar.setProgress(arr.length, arr.length);            
        }
        
        private function convertFile(file:File):void {
            var code:String;
            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.READ);
            try {
                code = fileStream.readUTFBytes(fileStream.bytesAvailable);                
            } finally {
                fileStream.close();
            }
            while (code.search("\r")>-1)
                code = code.replace("\r","");
            var converter:Converter = new Converter(code);
            var as3Code:String = converter.getNewClass();
            writeFile(file, as3Code); 
        }
        
        private function writeFile(orig:File, as3Code:String):void {
            var dest:File = _outputDir.resolvePath(orig.name.replace(".java", ".as"));
            var fileStream : FileStream = new FileStream();
            fileStream.open(dest, FileMode.WRITE);
            try {
                fileStream.writeUTFBytes(as3Code);                
            } finally {
                fileStream.close();
            }         
        }
    }
}