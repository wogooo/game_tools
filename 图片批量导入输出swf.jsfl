var folder=fl.browseForFolderURL("请选择图片目录");

var fileList=FLfile.listFolder(folder,"files");

///创建一个文档
var doc=fl.createDocument();
doc.frameRate=30;
doc.width=500;
doc.height=400;
doc.backgroundColor="#000000";
var fileLen=fileList.length;

for(var i=0;i<fileLen;++i)
{
	var filename=fileList[i];
	///导入png
	if(filename.toLowerCase().substr(filename.length - 4) == ".png")
	{
		doc.importFile(folder+"/"+filename,true);
	}
	
}
  var index=folder.lastIndexOf("/");
var storeUrl=folder.substring(0,index);
var  exportName=folder.substr(index+1)
//fl.trace(storeUrl);

//doc=fl.getDocumentDOM();
var libs=doc.library;
var len=libs.items.length;
fl.trace(len);
var item;
var pre="chitu_";

for(i=0;i<len;++i)
{
	item=libs.items[i];
	item.linkageExportForAS=true;
	item.linkageExportInFirstFrame=true;
	item.linkageExportForRS=false;	
	var index=item.name.indexOf(".");
	var myName=item.name.substr(0,item.name.length-4);
	item.linkageClassName=pre+myName;  //运行后即可导出东西
	
	//为了swf倒导出 必须将他们丢在舞台上
//	libs.selectItem(item.name);
//	libs.addItemToDocument({x:0,y:0});
	      //使用photo(JPEG)压缩
      item.compressionType="photo";
      item.quality = 60;
	  item.allowSmoothing=true;
     
      //使用文档的压缩质量，可在导出时设置
      item.useImportedJPEGQulity=true;
}
//doc.selectAll();
///全部在舞台上面的删除 要不然在程序中会多一份在舞台上面的实例
//doc.deleteSelection();
doc.exportSWF(storeUrl+"/"+exportName+".swf",false);
doc.close(false);
