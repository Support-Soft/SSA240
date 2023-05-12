dotnet
{
    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.HttpWebRequest"; "SSASSAHttpWebRequest")
        {
        }

        type("System.Net.HttpWebResponse"; "SSAHttpWebResponse")
        {
        }

        type("System.Net.HttpStatusCode"; "SSAHttpStatusCode")
        {
        }

        type("System.Net.HttpResponseHeader"; "SSAHttpResponseHeader")
        {
        }

        type("System.Net.WebException"; "SSAWebException")
        {
        }
        type("System.Collections.Specialized.NameValueCollection"; SSAResponseHeader)
        {

        }
    }

    assembly("System.Xml")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Xml.XmlDocument"; "SSAXmlDocument")
        {
        }

        type("System.Xml.NameTable"; "SSANameTable")
        {
        }

        type("System.Xml.XmlNamespaceManager"; "SSAXmlNamespaceManager")
        {
        }

        type("System.Xml.XmlNode"; "SSAXmlNode")
        {
        }

        type("System.Xml.XmlNodeList"; "SSAXmlNodeList")
        {
        }

        type("System.Xml.XmlNodeChangedEventArgs"; "SSAXmlNodeChangedEventArgs")
        {
        }
    }
}
