using System;
using System.Xml;

namespace scripts
{
    class Program
    {
        static void Main(string[] args)
        {
            var manifestFile = args[0];
            var key = args[1];
            var value = args[2];

            var doc = new XmlDocument();
            doc.Load(manifestFile);

            var metaData = doc.GetElementsByTagName("meta-data");

            foreach(XmlNode item in metaData)
                if (item.Attributes[0].InnerText == key)
                {
                    Console.WriteLine($"Original Value: {item.Attributes[1].Value}");
                    item.Attributes[1].Value = value;
                    Console.WriteLine($"New Value: {item.Attributes[1].Value}");
                }
            doc.Save(manifestFile);
        }
    }
}
