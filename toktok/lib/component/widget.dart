
import 'package:flutter/material.dart';
import 'package:toktok/component/theme.dart';


buildTextFormField(
    {
      required String text,
      required IconData iconPre,
      required var textInputType,
      required var onChanged,
      required var controller,
      required var validate,
      required bool obscureText,

    }
    )
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        controller: controller,
        //onSaved: onSaved,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          border: const UnderlineInputBorder(),
          labelText: text,
          labelStyle: headingStyle(color: Colors.black, fontSize: 18),
          prefixIcon: Icon(iconPre, color: Colors.teal,),
          suffixIcon: IconButton(onPressed: (){controller.text ="";},icon: const Icon(Icons.clear),color: Colors.teal,),
        ),
        keyboardType: textInputType,
        validator:validate,
        obscureText: obscureText,
        onChanged:onChanged

    ),
  );
}

buildMaterialButton({
  required Color color,
  required String text,
  required var function,
})
{
  return MaterialButton(
    color: color,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
    onPressed: function,
    child:Text(text ,style: headingStyle(
      color: Colors.white,
      fontSize: 16,
    )),
  );
}

buildIcon({
  required IconData icon,
  required Color color,
})
{
  return Icon(icon,color: color,);
}

buildIconButton(
    {
      required IconData icon,
      required Color color,
      required var onPressed,
    })
{
  return IconButton(
      onPressed: onPressed,
      icon: buildIcon(
          icon: icon,
          color: color
      )
  );
}

buildCheckBox(
    {
      required bool value,
      required String text,
      required var onChanged,
    })
{
  return CheckboxListTile(
    title: Text(text),
    autofocus: false,
    activeColor: Colors.indigo,
    checkColor: Colors.white,
    selected: value,
    value: value,
    onChanged:onChanged,
  );
}
buildTextFormFieldToReadOly(
    {
      required String text,
      required var controller,
      required IconData iconPre,
      required bool obscureText,

    }
    )
{
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(

        alignLabelWithHint: true,
        /*enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 1, color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(50),
          ),*/
        border: const UnderlineInputBorder(),
        labelText: text,
        labelStyle: headingStyle(color: Colors.black, fontSize: 20),
        prefixIcon: Icon(iconPre, color: Colors.teal,),
      ),
      readOnly: true,
    ),
  );
}

buildImage({
  required double radius ,
  required String imagePath ,
  required double h ,
  required double w
} )
{
  return Padding(
    padding: const EdgeInsets.all(10),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: Image.asset(imagePath,height: h,width: w,),
    ),
  );
}

buildText(
    {
      required String text,
      required Color color,
      required double fontSize,
    }
    )
{
  return Row(
    children: [
      Text(text,style: headingStyle(color: color, fontSize: fontSize,),),
    ],
  );
}

buildElevatedButton(
{
  required Color color,
  required String text,
  required var function,
  required IconData icon,
}
    )
{
  return ElevatedButton.icon(onPressed: function,
    icon:Icon(icon,color: Colors.yellow),
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      backgroundColor: color,
      maximumSize: const Size.fromHeight(50),
      elevation: 0,

    ),
    label: Text(text,style: headingStyle(color: Colors.white, fontSize: 16),),
  );
}